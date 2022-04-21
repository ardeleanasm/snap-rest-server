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

import InteractionsUtil



data InteractionsService = InteractionsService { _pg :: Snaplet Postgres}

makeLenses ''InteractionsService

interactionsRoutes :: [(B.ByteString, Handler b InteractionsService ())]
interactionsRoutes = [
               ("/drugs", method GET getDrugList)

              ] --, ("/", method POST createTodo)]


-- curl -XGET localhost:8000/api/interactions/drugs?list=umftenol,uvtenol,uptenol
-- umftenol,uvtenol,uptenol


queryDatabase::(B.ByteString,B.ByteString) ->[Interactions]
queryDatabase (drug1,drug2) = do
    interaction <- query "SELECT drug1name,drug2name,interactioncode FROM interactions WHERE drug1name = ? and drug2name = ?" ((B.unpack drug1)::String, (B.unpack drug2)::String):: [Interactions]
    return interaction




getDrugList :: Handler b InteractionsService ()
getDrugList = do
  drugList <- getQueryParam "list"
  let drugs = getDrugPairs $ show drugList
  let interactionPairs = map queryDatabase drugs
  modifyResponse $ setHeader "Content-type" "application/json"
  writeLBS . encode $ (interactionPairs :: [[Interactions]])
--  writeBS $ concat interactionPairs
--  writeBS $ show drugList
--  pairs <- getDrugPairs drugList
--  maybe (writeBS "must specify echo/param in URL")
--    writeBS $ getDrugPairs (show drugList)
  -- make pairs of drugs and check in database
    
 




interactionsServiceInit :: SnapletInit b InteractionsService
interactionsServiceInit = makeSnaplet "interactions" "Interaction Drugs Service" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes interactionsRoutes
  return $ InteractionsService pg

instance HasPostgres (Handler b InteractionsService) where
  getPostgresState = with pg get
  
