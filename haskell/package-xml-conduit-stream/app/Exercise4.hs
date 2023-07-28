{-# LANGUAGE OverloadedStrings #-}

module Exercise4 (exercise) where

import Conduit
  ( ConduitT,
    MonadIO,
    MonadThrow,
    PrimMonad,
    Void,
    builderToByteString,
    nullC,
    stdoutC,
    takeWhileC,
    (.|),
  )
import Control.Monad (unless)
import Data.Text (Text)
import Data.XML.Types (Content (..), Event (..))
import Text.XML (Name (..))
import Text.XML.Stream.Parse (many_, takeAnyTreeContent)
import Text.XML.Stream.Render (attr, content, def, renderBuilder, tag)

exercise :: (MonadThrow m, MonadIO m, PrimMonad m) => ConduitT Event Void m ()
exercise = transform .| renderBuilder def .| builderToByteString .| stdoutC

transform :: (MonadThrow m) => ConduitT Event Event m ()
transform = do
  takeWhileC (/= EventContent (ContentText "A Song of Ice and Fire"))
  atEndOfStream <- nullC
  unless atEndOfStream $ do
    takeWhileC (/= EventEndElement (gtr "content"))
    takeWhileC (== EventEndElement (gtr "content"))
    many_ takeAnyTreeContent
    tag (gtr "node") mempty $
      tag (gtr "content") (attr "type" "Dublin Core") $ do
        tag (dc "title") mempty (content "A Feast for Crows")
        tag (dc "date") mempty (content "2005")
    takeWhileC (const True)

gtr :: Text -> Name
gtr n =
  Name n (Just "http://martin.hoppenheit.info/code/generic-tree-xml") (Just "t")

dc :: Text -> Name
dc n = Name n (Just "http://purl.org/dc/elements/1.1/") (Just "e")
