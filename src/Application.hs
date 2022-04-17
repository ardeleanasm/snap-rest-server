{-# LANGUAGE TemplateHaskell #-}
module Application where

import Core
import Snap.Snaplet
import Control.Lens


data App=App { _api :: Snaplet Api}

makeLenses ''App

type AppHandler = Handler App App
