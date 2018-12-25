module Main where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import System.Environment (getArgs)

import Exercise1 as E1
import Exercise2 as E2
import Exercise3 as E3

main :: IO ()
main = do
    num <- read . head <$> getArgs
    xml <- TIO.readFile "../../xml/example.xml"
    TIO.putStr $
        case num of
            1 -> E1.exercise xml
            2 -> E2.exercise xml
            3 -> E3.exercise xml
            _ -> T.empty
