{-# LANGUAGE OverloadedStrings #-}

module Exercise8
    ( exercise
    ) where

import Data.List (groupBy)
import qualified Data.Text as T
import Safe (headMay)

import GtrDc

exercise :: T.Text -> T.Text
exercise = maybe "" (showXml . exercise') . readXml

exercise' :: GtrNode -> GtrNode
exercise' (GtrNode n es ns) =
    GtrNode n es (concatMap addParent $ groupBySubject ns)

groupBySubject :: [GtrNode] -> [[GtrNode]]
groupBySubject = groupBy (\x y -> subject x == subject y)

addParent :: [GtrNode] -> [GtrNode]
addParent ns =
    case headMay ns >>= subject of
        Just s -> [GtrNode (Just s) [] (map rmSubjects ns)]
        Nothing -> ns

subject :: GtrNode -> Maybe T.Text
subject (GtrNode _ (Subject t:_) _) = Just t
subject (GtrNode n (_:es) ns) = subject (GtrNode n es ns)
subject (GtrNode _ [] _) = Nothing

rmSubjects :: GtrNode -> GtrNode
rmSubjects (GtrNode n es ns) = GtrNode n (filter (not . isSubject) es) ns

isSubject :: DcElement -> Bool
isSubject (Subject _) = True
isSubject _ = False
