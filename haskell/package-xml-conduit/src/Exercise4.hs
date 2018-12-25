{-# LANGUAGE OverloadedStrings #-}

module Exercise4
    ( exercise
    ) where

import qualified Data.Text as T

import GtrDc

exercise :: T.Text -> T.Text
exercise = maybe "" (showXml . exercise') . readXml

exercise' :: GtrNode -> GtrNode
exercise' (GtrNode n es ns)
    | title es == "A Song of Ice and Fire" = GtrNode n es (ns ++ new)
    | otherwise = GtrNode n es (map exercise' ns)
  where
    new = [GtrNode Nothing [Title "A Feast for Crows", Date "2005"] []]

title :: [DcElement] -> T.Text
title (Title t:_) = t
title (_:es) = title es
title [] = ""
