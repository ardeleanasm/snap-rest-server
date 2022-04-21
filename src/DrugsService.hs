{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module DrugsService where

import Types
import Control.Lens
import Control.Monad.State.Class
import Data.Aeson
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple
import qualified Data.ByteString.Char8 as B


data DrugsService = DrugsService { _pg :: Snaplet Postgres}

makeLenses ''DrugsService

drugsRoutes :: [(B.ByteString, Handler b DrugsService ())]
drugsRoutes = [ ("/", method GET getDrugs)
              ] --, ("/", method POST createTodo)]


getDrugs :: Handler b DrugsService ()
getDrugs = do
  drugs <- query_ "SELECT * FROM drugs"
  modifyResponse $ setHeader "Content-type" "application/json"
  writeLBS . encode $ (drugs :: [Drugs])

drugsServiceInit :: SnapletInit b DrugsService
drugsServiceInit = makeSnaplet "drugs" "Get Drugs Service" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes drugsRoutes
  return $ DrugsService pg

instance HasPostgres (Handler b DrugsService) where
  getPostgresState = with pg get
  
