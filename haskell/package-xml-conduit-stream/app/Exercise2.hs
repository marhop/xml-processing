{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}

module Exercise2 (exercise) where

import Conduit
  ( ConduitT,
    MonadIO,
    MonadThrow,
    Void,
    liftIO,
    mapM_C,
    yield,
    (.|),
  )
import Control.Monad (void)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Data.Text.IO qualified as TIO
import Data.XML.Types (Event)
import Text.XML (Name (..))
import Text.XML.Stream.Parse
  ( NameMatcher (..),
    content,
    force,
    ignoreAttrs,
    many,
    matching,
    tag,
    tagIgnoreAttrs,
  )

exercise :: (MonadThrow m, MonadIO m) => ConduitT Event Void m ()
exercise =
  force "failed parsing XML" treeP
    .| mapM_C (liftIO . TIO.putStrLn . (\c -> c.creator <> ", " <> c.title))

data Content = Content {creator, title :: Text}
  deriving (Show)

treeP :: (MonadThrow m) => ConduitT Event Content m (Maybe ())
treeP = tagIgnoreAttrs (gtr "tree") (void . many $ nodeP "")

nodeP :: (MonadThrow m) => Text -> ConduitT Event Content m (Maybe ())
nodeP parentCreator = tagIgnoreAttrs (gtr "node") $ do
  mbContent <- contentP
  let cr =
        maybe
          parentCreator
          (\c -> if c.creator /= "" then c.creator else parentCreator)
          mbContent
  mbNode <- nodeP cr
  case mbNode of
    Just () -> void . many $ nodeP cr
    Nothing ->
      mapM_
        ( \c ->
            yield $ if c.creator /= "" then c else c {creator = parentCreator}
        )
        mbContent

contentP :: (MonadThrow m) => ConduitT Event o m (Maybe Content)
contentP = tagIgnoreAttrs (gtr "content") $ do
  elems <- many dcElemP
  pure $
    Content
      (fromMaybe "" $ lookup "creator" elems)
      (fromMaybe "" $ lookup "title" elems)

dcElemP :: (MonadThrow m) => ConduitT Event o m (Maybe (Text, Text))
dcElemP =
  tag
    (matching (\n -> n.nameNamespace == Just dcNs))
    (<$ ignoreAttrs)
    (\n -> (n.nameLocalName,) <$> content)

gtr :: Text -> NameMatcher Name
gtr n = matching (== Name n (Just gtrNs) (Just "t"))

gtrNs :: Text
gtrNs = "http://martin.hoppenheit.info/code/generic-tree-xml"

dcNs :: Text
dcNs = "http://purl.org/dc/elements/1.1/"
