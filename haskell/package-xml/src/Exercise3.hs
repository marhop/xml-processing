module Exercise3
    ( exercise
    ) where

import Data.Char
import Text.XML.Light

import Common

exercise :: String -> String
exercise = unlines . map (showContent . transform) . parseXML

-- | Make title elements uppercase, return all other content unchanged.
transform :: Content -> Content
transform (Elem e)
    | elName e == dc "title" = Elem e {elContent = map uc $ elContent e}
    | otherwise = Elem e {elContent = map transform $ elContent e}
  where
    uc (Text t) = Text t {cdData = map toUpper $ cdData t}
    uc x = x
transform x = x
