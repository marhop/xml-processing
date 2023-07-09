module Main where

import Conduit (runConduitRes, sinkNull, (.|))
import Exercise1 qualified as E1
import System.Environment (getArgs)
import Text.XML.Stream.Parse (def, parseFile)

main :: IO ()
main = do
  num <- read @Int . head <$> getArgs
  runConduitRes $
    parseFile def "../../xml/example.xml" .| case num of
      1 -> E1.exercise
      _ -> sinkNull
