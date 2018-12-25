{-# LANGUAGE OverloadedStrings #-}

module Exercise2
    ( exercise
    ) where

import Data.Monoid ((<>))
import qualified Data.Text as T

import GtrDc

exercise :: T.Text -> T.Text
exercise = maybe "" (T.unlines . exercise' "") . readXml

exercise' :: T.Text -> GtrNode -> [T.Text]
exercise' def (GtrNode _ es []) =
    [value "creator" def es <> ", " <> value "title" "" es]
exercise' def (GtrNode _ es ns) =
    concatMap (exercise' (value "creator" def es)) ns

value :: T.Text -> T.Text -> [DcElement] -> T.Text
value "creator" _ (Creator t:_) = t
value "title" _ (Title t:_) = t
value n def (_:es) = value n def es
value _ def [] = def
