{-# LANGUAGE OverloadedStrings #-}

module Exercise3 (exercise) where

import Conduit
  ( ConduitT,
    MonadIO,
    MonadThrow,
    PrimMonad,
    Void,
    nullC,
    stdoutC,
    takeWhileC,
    (.|),
  )
import Control.Monad (unless)
import Data.Text (toUpper)
import Data.XML.Types (Event (..))
import Text.XML (Name (..))
import Text.XML.Stream.Parse (matching, tagNoAttr)
import Text.XML.Stream.Parse qualified as Parse
import Text.XML.Stream.Render (content, def, renderBytes, tag)

exercise :: (MonadThrow m, MonadIO m, PrimMonad m) => ConduitT Event Void m ()
exercise = transform .| renderBytes def .| stdoutC

-- | Transform a stream of events: First, consume events (i.e., send them
-- downstream) until the opening tag of a title element is encountered. In that
-- case, parse the whole title element to obtain its text content and send a new
-- title element with the same but uppercased text content downstream. Repeat
-- until the end of input is reached.
transform :: (MonadThrow m) => ConduitT Event Event m ()
transform = do
  takeWhileC (/= EventBeginElement titleName [])
  atEndOfStream <- nullC
  unless atEndOfStream $ do
    t <- tagNoAttr (matching (== titleName)) Parse.content
    maybe (pure ()) (tag titleName mempty . content . toUpper) t
    transform

titleName :: Name
titleName = Name "title" (Just "http://purl.org/dc/elements/1.1/") (Just "e")
