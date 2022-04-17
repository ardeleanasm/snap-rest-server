{-# LANGUAGE OverloadedStrings #-}
module Site (
  app
  )where

import Core (Api(Api), apiInit)
import Control.Applicative
import Data.ByteString (ByteString)
import qualified Data.Text as T
import Snap.Core
import Snap.Snaplet


import Application

-- | routes
routes :: [(ByteString, Handler App App ())]
routes = []

app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
                    api <- nestSnaplet "api" api apiInit
                    addRoutes routes
                    return $ App api
