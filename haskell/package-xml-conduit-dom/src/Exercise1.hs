{-# LANGUAGE OverloadedStrings #-}

module Exercise1
    ( exercise
    ) where

import Data.Monoid ((<>))
import qualified Data.Text as T

import GtrDc

exercise :: T.Text -> T.Text
exercise = maybe "" (T.unlines . exercise') . readXml

exercise' :: GtrNode -> [T.Text]
exercise' (GtrNode _ es []) = [value "creator" es <> ", " <> value "title" es]
exercise' (GtrNode _ _ ns) = concatMap exercise' ns

value :: T.Text -> [DcElement] -> T.Text
value "creator" (Creator t:_) = t
value "title" (Title t:_) = t
value n (_:es) = value n es
value _ [] = ""
