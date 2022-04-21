{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module DbVersionService where

import Types
import Control.Lens
import Control.Monad.State.Class
import Data.Aeson
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple
import qualified Data.ByteString.Char8 as B


data DbVersionService = DbVersionService { _pg :: Snaplet Postgres}

makeLenses ''DbVersionService

versionRoutes :: [(B.ByteString, Handler b DbVersionService ())]
versionRoutes = [("/", method GET getVersion)] --, ("/", method POST createTodo)]





getVersion :: Handler b DbVersionService ()
getVersion = do
  dbVersion <- query_ "SELECT * FROM dbversion"
  modifyResponse $ setHeader "Content-type" "application/json"
  writeLBS . encode $ (dbVersion :: [DbVersion])

dbVersionServiceInit :: SnapletInit b DbVersionService
dbVersionServiceInit = makeSnaplet "version" "Get DbVersion Service" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes versionRoutes
  return $ DbVersionService pg

instance HasPostgres (Handler b DbVersionService) where
  getPostgresState = with pg get
  
