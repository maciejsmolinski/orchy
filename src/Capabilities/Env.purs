module Capabilities.Env where

import Control.Monad (class Monad)

class Monad m <= HasEnv m where
  getEnvInt :: String -> Int -> m Int
