{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module Types where

import Control.Applicative
import qualified Data.Text as T
import Data.Aeson 
import Snap.Snaplet.PostgresqlSimple

{-
data Todo = Todo
  { id :: Int
  , text :: T.Text
  }
-}
data Drugs = Drugs
  { id :: Int
  , drugname :: T.Text
  , rodrugname :: T.Text
  }

data DbVersion = DbVersion
  {
    dbversion :: T.Text
  }


data DbEntryInteractions = DbEntryInteractions
  { iid :: Int
  , drug1 :: T.Text
  , db1id :: T.Text
  , drug2 :: T.Text
  , db2id :: T.Text
  , interaction :: Int
  }

data Interactions = Interactions
  {
    drug1name :: T.Text
  , drug2name :: T.Text
  , druginteraction :: Int
  }
  

instance FromRow Drugs where
  fromRow = Drugs <$> field
                  <*> field
                  <*> field
                  

instance ToJSON Drugs where
  toJSON (Drugs id drugname rodrugname) = object [ "id" .= id, "drugname" .= drugname, "rodrugname" .= rodrugname ]

 
instance FromRow DbVersion where
  fromRow = DbVersion <$> field

instance ToJSON DbVersion where
  toJSON (DbVersion dbversion) = object [ "dbVersion" .= dbversion ]


instance FromRow DbEntryInteractions where
  fromRow = DbEntryInteractions <$> field
                                <*> field
                                <*> field
                                <*> field
                                <*> field
                                <*> field

instance ToJSON DbEntryInteractions where
  toJSON (DbEntryInteractions iid drug1 db1id drug2 db2id interaction) = object [ "id" .= iid
                                                                                       , "drug1name" .= drug1
                                                                                       , "db1id" .= db1id
                                                                                       , "drug2name" .= drug2
                                                                                       , "db2id" .= db2id
                                                                                       , "interaction" .= interaction]
instance FromRow Interactions where
  fromRow = Interactions <$> field
                         <*> field
                         <*> field




instance ToJSON Interactions where
  toJSON (Interactions drug1name drug2name druginteraction) = object [ "drug1name" .= drug1name
                                                                 , "drug2name" .= drug2name
                                                                 , "interaction" .= druginteraction]
