module Capabilities.HasRequest where

import Control.Monad (class Monad)
import Data.Unit (Unit)

class Monad m <= HasRequest m where
  post :: String -> String -> m Unit
