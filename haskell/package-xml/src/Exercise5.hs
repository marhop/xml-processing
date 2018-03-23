module Exercise5
    ( exercise
    ) where

import Text.XML.Light

exercise :: String -> String
exercise = unlines . map showContent . remove target . parseXML

-- | Recursively remove elements that satisfy the given predicate, return all
-- other content unchanged.
remove :: (Element -> Bool) -> [Content] -> [Content]
remove _ [] = []
remove p ((Elem e):cs)
    | p e = remove p cs
    | otherwise = (Elem e {elContent = remove p $ elContent e}) : remove p cs
remove p (c:cs) = c : remove p cs

-- | Determine whether an element is the target section of this exercise.
target :: Element -> Bool
target e = findAttr (unqual "name") e == Just "Programming Books"
