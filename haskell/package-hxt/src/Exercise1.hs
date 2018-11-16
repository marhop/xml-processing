module Exercise1
    ( exercise
    ) where

import Text.XML.HXT.Core

import Util

exercise :: ArrowXml a => a XmlTree String
exercise = propagateNamespaces >>> leafNodes >>> content

-- Find leaf nodes.
leafNodes :: ArrowXml a => a XmlTree XmlTree
leafNodes = deepest $ hasQName (gtr "node")

-- Extract and format the desired element content.
content :: ArrowXml a => a XmlTree String
content = value "creator" &&& value "title" >>> arr (\(c, t) -> c ++ ", " ++ t)

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
-- Then applying the filter @value "title"@ yields "The Lord of the Rings", and
-- @value "date"@ yields "".
value :: ArrowXml a => String -> a XmlTree String
value n =
    (this /> hasQName (gtr "content") /> hasQName (dc n) /> getText) `orElse`
    arr (const "")
