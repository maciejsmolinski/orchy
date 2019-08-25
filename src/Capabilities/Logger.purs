module Capabilities.Logger where

import Control.Monad (class Monad)
import Data.Unit (Unit)

class Monad m <= HasLogger m where
  log :: String -> m Unit
