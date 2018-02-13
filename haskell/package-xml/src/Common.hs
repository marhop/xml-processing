module Common
    ( gtr
    , dc
    , findPath
    ) where

import Text.XML.Light

-- | Create a QName in the Generic Tree namespace.
gtr :: String -> QName
gtr n = QName n ns prefix
  where
    ns = Just "http://martin.hoppenheit.info/code/generic-tree-xml"
    prefix = Just "t"

-- | Create a QName in the Dublin Core namespace.
dc :: String -> QName
dc n = QName n ns prefix
  where
    ns = Just "http://purl.org/dc/elements/1.1/"
    prefix = Just "e"

-- | Find descendant elements whose path is specified by a list of QNames. Like
-- a simple XPath expression. Note that @findPath [] e = [e]@.
findPath :: [QName] -> Element -> [Element]
findPath ns e = foldl (\es n -> concatMap (findChildren n) es) [e] ns
