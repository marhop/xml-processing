{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}

module Exercise1 (exercise) where

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

-- | Parse a @gtr:tree@ element, possibly containing @gtr:node@ elements. The
-- @node@ elements may contain @gtr:content@ elements whose content constitutes
-- the stream output.
treeP :: (MonadThrow m) => ConduitT Event Content m (Maybe ())
treeP = tagIgnoreAttrs (gtr "tree") (void $ many nodeP)

-- | Parse a @gtr:node@ element. The @node@ may optionally contain one
-- @gtr:content@ child element and a recursive list of @gtr:node@ children. If
-- the set of child @nodes@ is empty this is a leaf node, otherwise it's an
-- inner node. Only the @content@ of leaf nodes is sent down the stream, while
-- inner nodes are processed recursively.
nodeP :: (MonadThrow m) => ConduitT Event Content m (Maybe ())
nodeP = tagIgnoreAttrs (gtr "node") $ do
  mbContent <- contentP
  mbNode <- nodeP
  case mbNode of
    -- If there was one child node (parse result mbNode == Just ()) then the
    -- current node is an inner node, so we just look for more child nodes.
    Just () -> void $ many nodeP
    -- Otherwise (mbNode == Nothing) the current node is a leaf node, so we
    -- yield (i.e., send downstream) its content (if there is any).
    Nothing -> mapM_ yield mbContent

-- | Parse a @gtr:content@ element, possibly containing Dublin Core elements.
-- The content of @dc:creator@ and @dc:title@ elements (default empty string) is
-- returned and then sent down the stream by the 'nodeP' function.
contentP :: (MonadThrow m) => ConduitT Event o m (Maybe Content)
contentP = tagIgnoreAttrs (gtr "content") $ do
  elems <- many dcElemP
  pure $
    Content
      (fromMaybe "" $ lookup "creator" elems)
      (fromMaybe "" $ lookup "title" elems)

-- | Parse any Dublin Core element like @dc:title@.
dcElemP :: (MonadThrow m) => ConduitT Event o m (Maybe (Text, Text))
dcElemP =
  tag
    -- Match only on the namespace, not the local tag name, to match any DC
    -- element.
    (matching (\n -> n.nameNamespace == Just dcNs))
    -- Ignore attributes, but return the given tag name.
    (<$ ignoreAttrs)
    -- Return a (local tag name, element content) pair.
    (\n -> (n.nameLocalName,) <$> content)

gtr :: Text -> NameMatcher Name
gtr n = matching (== Name n (Just gtrNs) (Just "t"))

gtrNs :: Text
gtrNs = "http://martin.hoppenheit.info/code/generic-tree-xml"

dcNs :: Text
dcNs = "http://purl.org/dc/elements/1.1/"
