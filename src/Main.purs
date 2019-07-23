module Main where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Logger as Logger
import Orchestrator.FS (readFile)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (runDefinition)

main :: Effect Unit
main = do
  configuration <- readFile "configuration.json"
  case configuration of
    (Left _) -> Logger.error "⚠ Failure reading configuration.json"
    (Right contents) -> do
      parsed <- pure $ fromJSON contents
      case parsed of
        (Left error) -> Logger.error $ "⚠ " <> error
        (Right definition) -> runDefinition definition
