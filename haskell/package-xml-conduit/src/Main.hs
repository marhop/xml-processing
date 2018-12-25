module Main where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import System.Environment (getArgs)

import Exercise1 as E1

main :: IO ()
main = do
    num <- read . head <$> getArgs
    xml <- TIO.readFile "../../xml/example.xml"
    TIO.putStr $
        case num of
            1 -> E1.exercise xml
            _ -> T.empty
