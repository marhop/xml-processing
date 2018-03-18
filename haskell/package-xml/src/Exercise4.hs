module Exercise4
    ( exercise
    ) where

import Text.XML.Light

import Common

exercise :: String -> String
exercise = unlines . map (showContent . fixNamespace . transform) . parseXML

-- | Append the new child to the target element, return all other content
-- unchanged.
transform :: Content -> Content
transform (Elem e)
    | target e = Elem e {elContent = elContent e ++ [newItem]}
    | otherwise = Elem e {elContent = map transform $ elContent e}
transform x = x

-- | Determine whether an element is the target section of this exercise.
target :: Element -> Bool
target e = title == "A Song of Ice and Fire"
  where
    title =
        case findPath [(gtr "content"), (dc "title")] e of
            [] -> ""
            (e:_) -> strContent e

-- | The new item (child element for target section).
newItem :: Content
newItem = Elem node
  where
    node = blank_element {elName = gtr "node", elContent = [Elem content]}
    content =
        blank_element
        { elName = gtr "content"
        , elAttribs = [Attr (unqual "type") "Dublin Core"]
        , elContent = [Elem title, Elem date]
        }
    title =
        blank_element
        { elName = dc "title"
        , elContent = [Text (blank_cdata {cdData = "A Feast for Crows"})]
        }
    date =
        blank_element
        {elName = dc "date", elContent = [Text (blank_cdata {cdData = "2005"})]}
