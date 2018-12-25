{-# LANGUAGE OverloadedStrings #-}

module GtrDc
    ( GtrNode(..)
    , DcElement(..)
    , readXml
    , showXml
    ) where

import qualified Data.Map.Strict as Map
import Data.Maybe (listToMaybe, mapMaybe)
import Data.String.Conversions (cs)
import qualified Data.Text as T
import Text.XML
import Text.XML.Cursor

-- Data types

data GtrNode = GtrNode
    { nName :: Maybe T.Text
    , nContent :: [DcElement]
    , nChildren :: [GtrNode]
    } deriving (Show)

data DcElement
    = Title T.Text
    | Creator T.Text
    | Subject T.Text
    | Description T.Text
    | Publisher T.Text
    | Contributor T.Text
    | Date T.Text
    | Type T.Text
    | Format T.Text
    | Identifier T.Text
    | Source T.Text
    | Language T.Text
    | Relation T.Text
    | Coverage T.Text
    | Rights T.Text
    deriving (Show)

-- Read

readXml :: T.Text -> Maybe GtrNode
readXml =
    either (const Nothing) Just . parseText def . cs >=>
    readGtrNode . fromDocument

readGtrNode :: Cursor -> Maybe GtrNode
readGtrNode c
    | any (hasName c) [gtr "tree", gtr "node"] =
        Just
            GtrNode
            { nName = listToMaybe (c $| attribute "name")
            , nContent =
                  mapMaybe
                      readDcElement
                      (c $/ element (gtr "content") &/ anyElement)
            , nChildren = mapMaybe readGtrNode (c $/ element (gtr "node"))
            }
    | otherwise = Nothing

readDcElement :: Cursor -> Maybe DcElement
readDcElement c
    | c `hasName` dc "title" = Just $ Title t
    | c `hasName` dc "creator" = Just $ Creator t
    | c `hasName` dc "subject" = Just $ Subject t
    | c `hasName` dc "description" = Just $ Description t
    | c `hasName` dc "publisher" = Just $ Publisher t
    | c `hasName` dc "contributor" = Just $ Contributor t
    | c `hasName` dc "date" = Just $ Date t
    | c `hasName` dc "type" = Just $ Type t
    | c `hasName` dc "format" = Just $ Format t
    | c `hasName` dc "identifier" = Just $ Identifier t
    | c `hasName` dc "source" = Just $ Source t
    | c `hasName` dc "language" = Just $ Language t
    | c `hasName` dc "relation" = Just $ Relation t
    | c `hasName` dc "coverage" = Just $ Coverage t
    | c `hasName` dc "rights" = Just $ Rights t
    | otherwise = Nothing
  where
    t = T.concat (c $/ content)

hasName :: Cursor -> Name -> Bool
hasName c n = not $ null (c $| element n)

-- Show

showXml :: GtrNode -> T.Text
showXml = cs . renderText (def {rsNamespaces = namespaces}) . showGtrTree

showGtrTree :: GtrNode -> Document
showGtrTree n =
    Document
    { documentPrologue = Prologue [] Nothing []
    , documentRoot = (showGtrNode n) {elementName = gtr "tree"}
    , documentEpilogue = []
    }

showGtrNode :: GtrNode -> Element
showGtrNode n =
    Element
    { elementName = gtr "node"
    , elementAttributes = maybe Map.empty (Map.singleton "name") (nName n)
    , elementNodes =
          if null (nContent n)
              then childNodes
              else content : childNodes
    }
  where
    content = NodeElement (showGtrContent $ nContent n)
    childNodes = map (NodeElement . showGtrNode) (nChildren n)

showGtrContent :: [DcElement] -> Element
showGtrContent es =
    Element
    { elementName = gtr "content"
    , elementAttributes = Map.singleton "type" "Dublin Core"
    , elementNodes = map (NodeElement . showDcElement) es
    }

showDcElement :: DcElement -> Element
showDcElement (Title t) = dcElement "title" t
showDcElement (Creator t) = dcElement "creator" t
showDcElement (Subject t) = dcElement "subject" t
showDcElement (Description t) = dcElement "description" t
showDcElement (Publisher t) = dcElement "publisher" t
showDcElement (Contributor t) = dcElement "contributor" t
showDcElement (Date t) = dcElement "date" t
showDcElement (Type t) = dcElement "type" t
showDcElement (Format t) = dcElement "format" t
showDcElement (Identifier t) = dcElement "identifier" t
showDcElement (Source t) = dcElement "source" t
showDcElement (Language t) = dcElement "language" t
showDcElement (Relation t) = dcElement "relation" t
showDcElement (Coverage t) = dcElement "coverage" t
showDcElement (Rights t) = dcElement "rights" t

dcElement :: T.Text -> T.Text -> Element
dcElement n t = Element (dc n) Map.empty [NodeContent t]

-- Utilities

namespaces :: [(T.Text, T.Text)]
namespaces =
    [ ("t", "http://martin.hoppenheit.info/code/generic-tree-xml")
    , ("e", "http://purl.org/dc/elements/1.1/")
    ]

nsName :: T.Text -> T.Text -> Name
nsName p n = Name n (lookup p namespaces) (Just p)

gtr :: T.Text -> Name
gtr = nsName "t"

dc :: T.Text -> Name
dc = nsName "e"
