module Util
    ( el
    , gtr
    , dc
    ) where

import Text.XML.HXT.Core

-- | Test for elements with the given QName.
el :: ArrowXml a => QName -> a XmlTree XmlTree
el n = isElem >>> hasQName n

-- | Create a QName in the Generic Tree namespace.
gtr :: String -> QName
gtr n = mkQName "t" n "http://martin.hoppenheit.info/code/generic-tree-xml"

-- | Create a QName in the Dublin Core namespace.
dc :: String -> QName
dc n = mkQName "e" n "http://purl.org/dc/elements/1.1/"
