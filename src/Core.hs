{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Core where

import TodoService
import Snap.Core
import Snap.Snaplet
import Control.Lens

import qualified Data.ByteString.Char8 as B

data Api = Api {_todoService :: Snaplet TodoService}

makeLenses ''Api

apiRoutes :: [(B.ByteString,Handler b Api ())]
apiRoutes = [("status", method GET respondOk)]


respondOk :: Handler b Api ()
respondOk = do
  modifyResponse . setResponseCode $ 200


apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Core Api" Nothing $ do
  ts <- nestSnaplet "todos" todoService todoServiceInit
  addRoutes apiRoutes
  return $ Api ts
