module Exercise1
    ( exercise
    ) where

import Text.XML.HXT.Core

import Util

-- | Extract creator and title from all leaf nodes.
--
-- Make all elements in the tree namespace aware so they know their qualified
-- names, find the leaf nodes (very conveniently with @deepest@), get creator
-- and title values and combine them into a comma separated string.
exercise :: ArrowXml a => a XmlTree String
exercise =
    propagateNamespaces >>>
    deepest (hasQName (gtr "node")) >>>
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
    (this /> hasQName (gtr "content") /> hasQName (dc n) /> getText) `orElse`
    arr (const "")
