module Exercise1
    ( exercise
    ) where

import Text.XML.Light

import Common

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
