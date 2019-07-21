module Main where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Class.Console (warn)
import Orchestrator.FS (read)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (runDefinition)

main :: Effect Unit
main = do
  configuration <- read "configuration.json"
  case (fromJSON <$> configuration) of
    (Left _) -> warn "⚠ Failure reading configuration.json"
    (Right definition) -> do
      runDefinition definition
