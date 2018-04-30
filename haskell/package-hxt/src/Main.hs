module Main where

import System.Environment
import Text.XML.HXT.Core

main :: IO ()
main = do
    results <- runX (readDocument [] "../../xml/example.xml" >>> exercise)
    putStr $ unlines results

-- | Extract creator and title from all leaf nodes.
--
-- Make all elements in the tree namespace aware so they know their qualified
-- names, find the leaf nodes (very conveniently with @deepest@), get creator
-- and title values and combine them into a comma separated string.
exercise :: ArrowXml a => a XmlTree String
exercise =
    propagateNamespaces >>>
    deepest (el (gtr "node")) >>>
    content "creator" &&& content "title" >>> arr (\(c, t) -> c ++ ", " ++ t)

-- | Get the value of a node's content child element (default empty string).
--
-- Given the following XmlTree:
--
-- > <gtr:node>
-- >   <gtr:content>
-- >     <dc:title>The Lord of the Rings</dc:title>
-- >     <dc:creator>J. R. R. Tolkien</dc:creator>
-- >   </gtr:content>
-- > </gtr:node>
--
-- Then applying the filter @content "title"@ yields "The Lord of the Rings",
-- and @content "date"@ yields "".
content :: ArrowXml a => String -> a XmlTree String
content n =
    (this /> el (gtr "content") /> el (dc n) /> getText) `orElse` arr (const "")

-- | Test for elements with the given QName.
el :: ArrowXml a => QName -> a XmlTree XmlTree
el n = isElem >>> hasQName n

-- | Create a QName in the Generic Tree namespace.
gtr :: String -> QName
gtr n = mkQName "t" n "http://martin.hoppenheit.info/code/generic-tree-xml"

-- | Create a QName in the Dublin Core namespace.
dc :: String -> QName
dc n = mkQName "e" n "http://purl.org/dc/elements/1.1/"
