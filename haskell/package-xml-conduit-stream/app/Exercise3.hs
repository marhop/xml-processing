{-# LANGUAGE OverloadedStrings #-}

module Exercise3 (exercise) where

import Conduit
  ( ConduitT,
    MonadIO,
    MonadThrow,
    PrimMonad,
    Void,
    await,
    builderToByteString,
    stdoutC,
    yield,
    (.|),
  )
import Control.Monad (when)
import Data.Text (toUpper)
import Data.XML.Types (Content (..), Event (..))
import Text.XML (Name (..))
import Text.XML.Stream.Render (def, renderBuilder)

exercise :: (MonadThrow m, MonadIO m, PrimMonad m) => ConduitT Event Void m ()
exercise = transform .| renderBuilder def .| builderToByteString .| stdoutC

transform :: (Monad m) => ConduitT Event Event m ()
transform = do
  mx <- await
  case mx of
    Nothing -> pure ()
    Just x -> do
      yield x
      when (x == EventBeginElement titleName []) $ do
        my <- await
        case my of
          Nothing -> pure ()
          Just (EventContent (ContentText t)) ->
            yield $ EventContent (ContentText $ toUpper t)
          Just y -> yield y
      transform

titleName :: Name
titleName = Name "title" (Just "http://purl.org/dc/elements/1.1/") (Just "e")
