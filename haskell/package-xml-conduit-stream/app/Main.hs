module Main where

import Conduit (runConduitRes, sinkNull, (.|))
import Exercise1 qualified as E1
import Exercise2 qualified as E2
import Exercise3 qualified as E3
import Exercise4 qualified as E4
import System.Environment (getArgs)
import Text.XML.Stream.Parse (def, parseFile)

main :: IO ()
main = do
  num <- read @Int . head <$> getArgs
  runConduitRes $
    parseFile def "../../xml/example.xml" .| case num of
      1 -> E1.exercise
      2 -> E2.exercise
      3 -> E3.exercise
      4 -> E4.exercise
      _ -> sinkNull
