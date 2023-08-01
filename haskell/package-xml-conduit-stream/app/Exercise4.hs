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

-- | Transform a stream of events: First, consume events (i.e., send them
-- downstream) until the text content "A Song of Ice and Fire" is encountered
-- (note that this is a little fragile because that text could of course appear
-- anywhere, but well). From there, find the closing tag of the content block
-- and send that downstream as well. After that, consume any number of complete
-- subtrees (i.e., possible child nodes of the current node; these are the only
-- valid sibling elements of the content block that was just closed). After
-- that, the next event must be the closing tag of the current node, so now is
-- the time to create the new "A Feast for Crows" item and send that downstream.
-- Finally the remaining events (i.e., the rest of the XML tree) can be consumed
-- without further processing.
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
