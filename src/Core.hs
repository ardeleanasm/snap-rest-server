{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Core where

--import TodoService
import InteractionsService
import DrugsService
import DbVersionService
import Snap.Core
import Snap.Snaplet
import Control.Lens

import qualified Data.ByteString.Char8 as B


data Api = Api {_drugsService :: Snaplet DrugsService
               ,_dbVersionService :: Snaplet DbVersionService
               ,_interactionsService :: Snaplet InteractionsService}

makeLenses ''Api

apiRoutes :: [(B.ByteString,Handler b Api ())]
apiRoutes = [("status", method GET respondOk)]


respondOk :: Handler b Api ()
respondOk = do
  modifyResponse . setResponseCode $ 200


apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Core Api" Nothing $ do
  ds <- nestSnaplet "drugs" drugsService drugsServiceInit
  vs <- nestSnaplet "version" dbVersionService dbVersionServiceInit
  is <- nestSnaplet "interactions" interactionsService interactionsServiceInit
  addRoutes apiRoutes
  return $ Api ds vs is
