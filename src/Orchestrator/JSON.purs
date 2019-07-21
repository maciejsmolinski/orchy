module Orchestrator.JSON where

import Data.Either (Either)
import Data.List.NonEmpty (NonEmptyList)
import Foreign (ForeignError)
import Orchestrator.Main (Definition, makeCommand, makeDefinition)
import Simple.JSON as SimpleJSON

fromJSON :: String -> Definition
fromJSON _ = makeDefinition [makeCommand "echo" ["success"]]
  where
    decode :: String -> Either (NonEmptyList ForeignError) Definition
    decode = SimpleJSON.readJSON
