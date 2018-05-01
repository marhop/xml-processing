module Main where

import System.Environment
import Text.XML.HXT.Core

import Exercise1 as E1

main :: IO ()
main = do
    num <- read . head <$> getArgs
    results <-
        runX
            (readDocument [] "../../xml/example.xml" >>>
             case num of
                 1 -> E1.exercise
                 _ -> arr (const ""))
    putStr $ unlines results
