module Orchestrator.JSON (fromJSON) where

import Control.Applicative (pure)
import Data.Array (head, tail)
import Data.Either (Either(..))
import Data.Function (identity, ($))
import Data.Functor (map)
import Data.Maybe (maybe)
import Data.String (Pattern(..), split)
import Foreign (MultipleErrors)
import Orchestrator.Main (Command, Definition, makeCommand, makeDefinition, makeId)
import Simple.JSON as SimpleJSON

type JSONCommand = String
type JSONDefinition =
  { id :: String
  , commands :: Array JSONCommand }

fromJSON :: String -> Either String Definition
fromJSON text = value
  where
    result :: Either MultipleErrors JSONDefinition
    result = SimpleJSON.readJSON text

    value :: Either String Definition
    value = case result of
      (Left _) -> Left "Configuration file is not structured properly"
      (Right json) -> pure $ makeDefinition (makeId json.id) (map stringToCommand json.commands)

stringToCommand :: String -> Command
stringToCommand text = makeCommand program args
  where
    parts :: Array String
    parts = split (Pattern " ") text

    program :: String
    program = maybe "" identity (head parts)

    args :: Array String
    args = maybe [] identity (tail parts)
