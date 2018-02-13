module Exercise1
    ( exercise
    ) where

import Text.XML.Light

exercise :: String -> String
exercise xml =
    case parseXMLDoc xml of
        Nothing -> ""
        Just root -> unlines $ map content $ leafNodes root

-- | Find the leaf nodes of an element.
leafNodes :: Element -> [Element]
leafNodes e
    | null cs =
        if (elName e == gtr "node")
            then [e]
            else []
    | otherwise = concatMap leafNodes cs
  where
    cs = findChildren (gtr "node") e

-- | Extract and format the desired element content.
content :: Element -> String
content e = value "creator" ++ ", " ++ value "title"
  where
    value n =
        case findPath [(gtr "content"), (dc n)] e of
            [] -> ""
            (e:_) -> strContent e

-- | Find descendant elements whose path is specified by a list of QNames. Like
-- a simple XPath expression. Note that @findPath [] e = [e]@.
findPath :: [QName] -> Element -> [Element]
findPath ns e = foldl (\es n -> concatMap (findChildren n) es) [e] ns

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
