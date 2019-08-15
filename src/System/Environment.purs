module System.Environment (readEnvString, readEnvInt) where

import Control.Applicative (pure)
import Control.Monad (bind, (>>=))
import Data.Function (identity, ($))
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Node.Process (lookupEnv)
import Simple.JSON (readJSON_)

readEnvString :: String -> String -> Effect String
readEnvString variable defaultValue = do
  maybeValue <- lookupEnv variable
  pure $ maybe defaultValue identity maybeValue

readEnvInt :: String -> Int -> Effect Int
readEnvInt variable defaultValue = do
  maybeValue <- lookupEnv variable
  case (maybeValue >>= readJSON_ :: Maybe Int) of
    Nothing -> pure defaultValue
    (Just value) -> pure value
