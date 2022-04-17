{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_rest_server_snap (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/mihai/.cabal/bin"
libdir     = "/home/mihai/.cabal/lib/x86_64-linux-ghc-8.8.4/rest-server-snap-0.1.0.0-inplace-rest-server-snap"
dynlibdir  = "/home/mihai/.cabal/lib/x86_64-linux-ghc-8.8.4"
datadir    = "/home/mihai/.cabal/share/x86_64-linux-ghc-8.8.4/rest-server-snap-0.1.0.0"
libexecdir = "/home/mihai/.cabal/libexec/x86_64-linux-ghc-8.8.4/rest-server-snap-0.1.0.0"
sysconfdir = "/home/mihai/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "rest_server_snap_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "rest_server_snap_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "rest_server_snap_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "rest_server_snap_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "rest_server_snap_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "rest_server_snap_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
