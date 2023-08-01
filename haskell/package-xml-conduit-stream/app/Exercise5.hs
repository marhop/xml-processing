{-# LANGUAGE OverloadedStrings #-}

module Exercise5 (exercise) where

import Conduit
  ( ConduitT,
    MonadIO,
    MonadThrow,
    PrimMonad,
    Void,
    builderToByteString,
    stdoutC,
    takeWhileC,
    (.|),
  )
import Data.Text (Text)
import Data.XML.Types (Content (..), Event (..))
import Text.XML (Name (..))
import Text.XML.Stream.Parse (ignoreAnyTreeContent)
import Text.XML.Stream.Render (def, renderBuilder)

exercise :: (MonadThrow m, MonadIO m, PrimMonad m) => ConduitT Event Void m ()
exercise = transform .| renderBuilder def .| builderToByteString .| stdoutC

-- | Transform a stream of events: Consume events until the next one is the
-- starting tag of the "Programming Books" node. Then, skip (do not send
-- downstream) the next subtree, which is exactly the "Programming Books" node.
-- Finally just consume the rest of the stream.
transform :: (MonadThrow m) => ConduitT Event Event m ()
transform = do
  takeWhileC
    ( /=
        EventBeginElement
          (gtr "node")
          [("name", [ContentText "Programming Books"])]
    )
  _ <- ignoreAnyTreeContent
  takeWhileC (const True)

gtr :: Text -> Name
gtr n =
  Name n (Just "http://martin.hoppenheit.info/code/generic-tree-xml") (Just "t")
