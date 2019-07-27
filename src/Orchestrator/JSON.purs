module Orchestrator.JSON (fromJSON) where

import Control.Applicative (pure)
import Data.Array (head, tail)
import Data.Either (Either(..))
import Data.Function (identity, ($))
import Data.Functor (map)
import Data.Maybe (maybe)
import Data.String (Pattern(..), split)
import Foreign (MultipleErrors)
import Orchestrator.Main (Command, Definitions, makeCommand, makeDefinition, makeDefinitions, makeDir, makeId, makeSecret)
import Simple.JSON as SimpleJSON

type JSONDefinition =
  { id :: String
  , secret :: String
  , dir :: String
  , commands :: Array String }

type JSONDefinitions = Array JSONDefinition

fromJSON :: String -> Either String Definitions
fromJSON text = value
 where
    result :: Either MultipleErrors JSONDefinitions
    result = SimpleJSON.readJSON text

    value :: Either String Definitions
    value = case result of
      (Left _) -> Left "Configuration file is not structured properly"
      (Right json) -> pure $ makeDefinitions $ map (\definition -> makeDefinition (makeId definition.id) (makeSecret definition.secret) (makeDir definition.dir) (map stringToCommand definition.commands)) json

stringToCommand :: String -> Command
stringToCommand text = makeCommand program args
  where
    parts :: Array String
    parts = split (Pattern " ") text

    program :: String
    program = maybe "" identity (head parts)

    args :: Array String
    args = maybe [] identity (tail parts)
