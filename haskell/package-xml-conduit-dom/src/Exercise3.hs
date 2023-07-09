{-# LANGUAGE OverloadedStrings #-}

module Exercise3
    ( exercise
    ) where

import qualified Data.Text as T

import GtrDc

exercise :: T.Text -> T.Text
exercise = maybe "" (showXml . exercise') . readXml

exercise' :: GtrNode -> GtrNode
exercise' (GtrNode n es ns) = GtrNode n (map ucTitle es) (map exercise' ns)

ucTitle :: DcElement -> DcElement
ucTitle (Title t) = Title (T.toUpper t)
ucTitle e = e
