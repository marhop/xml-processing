{-# LANGUAGE OverloadedStrings #-}

module Exercise1Simple
    ( exercise
    ) where

import Data.Semigroup ((<>))
import Data.String.Conversions (cs)
import qualified Data.Text as T
import Text.XML
import Text.XML.Cursor

exercise :: T.Text -> T.Text
exercise = either (const "") exercise' . parseText def . cs

exercise' :: Document -> T.Text
exercise' d = T.unlines (fromDocument d $// leafNode &/ nodeContent)

-- | Find leaf nodes. Make sure an element is a gtr:node and that none of its
-- descendants is also a gtr:node.
leafNode :: Cursor -> [Cursor]
leafNode = element (gtr "node") >=> check (null . ($// element (gtr "node")))

-- | Extract and format the desired element content.
nodeContent :: Cursor -> [T.Text]
nodeContent = fmt . (value "creator" <> value "title")
  where
    fmt [] = []
    fmt xs = [T.intercalate ", " xs]
    value n = element (gtr "content") &/ element (dc n) &/ content

-- Create a Name in the Generic Tree namespace.
gtr :: T.Text -> Name
gtr n = Name n ns prefix
  where
    ns = Just "http://martin.hoppenheit.info/code/generic-tree-xml"
    prefix = Just "t"

-- Create a Name in the Dublin Core namespace.
dc :: T.Text -> Name
dc n = Name n ns prefix
  where
    ns = Just "http://purl.org/dc/elements/1.1/"
    prefix = Just "e"
