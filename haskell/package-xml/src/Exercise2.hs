module Exercise2
    ( exercise
    ) where

import Text.XML.Light

import Common

exercise :: String -> String
exercise xml =
    case parseXMLDoc xml of
        Nothing -> ""
        Just root -> unlines $ map content $ leafNodes "" root

-- | Find the leaf nodes of an element. Accept (and return) a default for the
-- creator value that will be updated during tree traversal.
leafNodes :: String -> Element -> [(Element, String)]
leafNodes def e
    | null cs =
        if (elName e == gtr "node")
            then [(e, cr)]
            else []
    | otherwise = concatMap (leafNodes cr) cs
  where
    cs = findChildren (gtr "node") e
    cr = value "creator" def e

-- | Extract and format the desired element content. Accept a default for the
-- creator value.
content :: (Element, String) -> String
content (e, def) = value "creator" def e ++ ", " ++ value "title" "" e

-- | Retrieve the value of a node's content field. Accept a default value for
-- nonexistent fields.
value :: String -> String -> Element -> String
value n def e =
    case findPath [(gtr "content"), (dc n)] e of
        [] -> def
        (e:_) -> strContent e
