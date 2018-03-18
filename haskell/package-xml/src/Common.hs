module Common
    ( gtr
    , dc
    , findPath
    , fixNamespace
    ) where

import Data.List (nub)
import Data.Maybe (fromMaybe, isJust)
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

-- | Add namespace declarations to an element for all namespaces that are used
-- in this element and its children. This fixes an issue with the Text.XML.Light
-- module not adding namespace URIs to XML output, see
-- <https://github.com/GaloisInc/xml/issues/10>.
fixNamespace :: Content -> Content
fixNamespace (Elem e) = Elem e {elAttribs = nub $ elAttribs e ++ namespaces e}
fixNamespace x = x

-- | Find all namespaces that are used in an element and its children and create
-- a list of namespace declaration attributes.
namespaces :: Element -> [Attr]
namespaces e
    | hasNamespace e = a : concatMap namespaces (elChildren e)
    | otherwise = concatMap namespaces (elChildren e)
  where
    hasNamespace = isJust . qURI . elName
    p = fromMaybe "" . qPrefix $ elName e
    u = fromMaybe "" . qURI $ elName e
    a = Attr (blank_name {qName = p, qPrefix = Just "xmlns"}) u
