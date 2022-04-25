{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module InteractionsService where

import Types
import Control.Lens
import Control.Monad.State.Class
import Data.Aeson
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple
import qualified Data.ByteString.Char8 as B
import Data.Text.Encoding as TSE
import InteractionsUtil
import Control.Monad
import qualified Data.String as DS


data InteractionsService = InteractionsService { _pg :: Snaplet Postgres}

makeLenses ''InteractionsService

interactionsRoutes :: [(B.ByteString, Handler b InteractionsService ())]
interactionsRoutes = [
               ("/drugs", method GET getDrugList)

              ] --, ("/", method POST createTodo)]


-- curl -XGET localhost:8000/api/interactions/drugs?list=macimorelin,naproxen,metformin
-- umftenol,uvtenol,uptenol




makeQuery::B.ByteString->B.ByteString->Query
makeQuery drug1 drug2 = DS.fromString ("SELECT drug1,drug2,interaction FROM interactions WHERE drug1 = '"++newdrug1++"' and drug2 = '"++newdrug2++"'")
  where
    newdrug1 = B.unpack drug1
    newdrug2 = B.unpack drug2


getDrugList :: Handler b InteractionsService ()
getDrugList = do
  drugList <- getQueryParam "list"
  case drugList of
    Just a -> do
      let drugs = getDrugPairs $ B.unpack a
      modifyResponse $ setHeader "Content-type" "application/json"
      forM_ drugs $ \(drug1,drug2) -> do
--   logError ((B.pack "Drug Pair") <> drug1 <> drug2)
        let theQuery = makeQuery drug1 drug2
        pair<-query_ theQuery
        writeLBS . encode $ (pair::[Interactions])
    Nothing -> writeBS "must specify param in URL"

--curl -XGET localhost:8000/api/interactions/drugs?list=uptenol,umftenol,uvtenol
      

                                                               
  
    


interactionsServiceInit :: SnapletInit b InteractionsService
interactionsServiceInit = makeSnaplet "interactions" "Interaction Drugs Service" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes interactionsRoutes
  return $ InteractionsService pg

instance HasPostgres (Handler b InteractionsService) where
  getPostgresState = with pg get
  
