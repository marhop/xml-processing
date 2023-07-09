{-# LANGUAGE OverloadedStrings #-}

module Exercise7
    ( exercise
    ) where

import Data.Maybe (fromMaybe)
import qualified Data.Text as T

import GtrDc

exercise :: T.Text -> T.Text
exercise = maybe "" (showXml . exercise') . readXml

exercise' :: GtrNode -> GtrNode
exercise' (GtrNode n es ns) = GtrNode n es (concatMap flatten ns)

flatten :: GtrNode -> [GtrNode]
flatten (GtrNode n _ ns) = map (addSubject n) ns

addSubject :: Maybe T.Text -> GtrNode -> GtrNode
addSubject (Just t) (GtrNode n es ns) = GtrNode n (Subject t : es) ns
addSubject Nothing n = n
