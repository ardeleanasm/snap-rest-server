{-# LANGUAGE OverloadedStrings #-}

module InteractionsUtil where

import qualified Data.ByteString.Char8 as B
import Data.List.Split
import Types



createPairs::[B.ByteString]->[(B.ByteString,B.ByteString)]
createPairs drugList = [(x,y) | x<-drugList, y<-drugList, x/=y]

filterDrugs::[(B.ByteString,B.ByteString)] -> [(B.ByteString,B.ByteString)]->[(B.ByteString,B.ByteString)]
filterDrugs [] filtered = filtered
filterDrugs (x:xs) filtered
  | inList x filtered== False = filterDrugs xs (filtered++[x])
  | otherwise = filterDrugs xs filtered
  where inList (a,b) drugs = if (a,b) `elem` drugs then True else
                                 if (b,a) `elem` drugs then True else False





getDrugPairs::String->[(B.ByteString,B.ByteString)]
getDrugPairs drugList = filterDrugs (createPairs $ map B.pack (splitOn "," drugList)) []





