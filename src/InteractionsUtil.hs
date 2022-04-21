{-# LANGUAGE OverloadedStrings #-}

module InteractionsUtil where

import qualified Data.ByteString.Char8 as B
import Data.List.Split
import Types



createPairs::[B.ByteString]->[(B.ByteString,B.ByteString)]
createPairs drugList = [(x,y) | x<-drugList, y<-drugList, x/=y, y>=x]


getDrugPairs::String->[(B.ByteString,B.ByteString)]
getDrugPairs drugList = createPairs $ map B.pack (splitOn " " drugList)




findInteractions::String -> Interactions
findInteractions drug = Interactions "sth" "sth" 1
