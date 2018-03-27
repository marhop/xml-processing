module Exercise7
    ( exercise
    ) where

import Data.Maybe (fromMaybe)
import Text.XML.Light

import Common

exercise :: String -> String
exercise = unlines . map (showContent . fixNamespace . flatten) . parseXML

-- | Remove the immediate child nodes of the given element.
flatten :: Content -> Content
flatten (Elem e) = Elem e {elContent = concatMap removeTopNode $ elContent e}
flatten c = c

-- | Replace an element by its children, adding the required content/subject
-- child elements along the way.
removeTopNode :: Content -> [Content]
removeTopNode (Elem e) = map (addSubject s) $ elContent e
  where
    s = fromMaybe "" (findAttr (unqual "name") e)
removeTopNode c = [c]

-- | Add an content/subject child element with the given text content to the
-- given element.
addSubject :: String -> Content -> Content
addSubject s (Elem e)
    | elName e == gtr "node" =
        Elem e {elContent = map (addSubject' s) $ elContent e}
    | otherwise = Elem e
addSubject _ c = c

addSubject' :: String -> Content -> Content
addSubject' s (Elem e)
    | elName e == gtr "content" =
        Elem
            e
            { elContent =
                  elContent e ++
                  [ Elem
                        blank_element
                        { elName = dc "subject"
                        , elContent = [Text blank_cdata {cdData = s}]
                        }
                  ]
            }
    | otherwise = Elem e
addSubject' _ c = c
