{-# LANGUAGE OverloadedStrings #-}

module Exercise5
    ( exercise
    ) where

import qualified Data.Text as T

import GtrDc

exercise :: T.Text -> T.Text
exercise = maybe "" (showXml . exercise') . readXml

-- NB, this won't work if "Programming Books" is the root node (which, however,
-- is called tree in XML)!
exercise' :: GtrNode -> GtrNode
exercise' (GtrNode n es ns) =
    GtrNode n es (map exercise' (filter notProgBooks ns))
  where
    notProgBooks n = nName n /= Just "Programming Books"
