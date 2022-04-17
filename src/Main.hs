{-# LANGUAGE TemplateHaskell #-}
module Main where

import Control.Exception (SomeException, try)
import Data.Text as T
import Snap.Http.Server
import Snap.Snaplet
import Snap.Snaplet.Config
import Snap.Core
import System.IO

import Site

import Snap.Loader.Static

main :: IO ()
main = do
  (conf, site, cleanup) <- $(loadSnapTH [| getConf |]
                            'getActions
                            [])
  _ <- try $ httpServe conf site :: IO (Either SomeException ())
  cleanup

getConf :: IO (Config Snap AppConfig)
getConf = commandLineAppConfig defaultConfig

getActions :: Config Snap AppConfig -> IO (Snap (), IO ())
getActions conf = do
  (msgs, site, cleanup) <- runSnaplet
    (appEnvironment =<< getOther conf) app
  hPutStrLn stderr $ T.unpack msgs
  return (site, cleanup)
