module Main where

import System.Environment
import Text.XML.Light

import Exercise1 as E1
import Exercise2 as E2
import Exercise3 as E3
import Exercise4 as E4

main :: IO ()
main = do
    num <- fmap (read . head) getArgs
    xml <- readFile "../../xml/example.xml"
    putStr $
        case num of
            1 -> E1.exercise xml
            2 -> E2.exercise xml
            3 -> E3.exercise xml
            4 -> E4.exercise xml
            _ -> ""
