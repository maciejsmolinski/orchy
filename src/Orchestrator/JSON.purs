module Orchestrator.JSON (fromJSON) where

import Data.Array (head, tail)
import Data.Either (Either, either)
import Data.Function (const, identity, ($))
import Data.Functor (map)
import Data.List.NonEmpty (NonEmptyList)
import Data.Maybe (maybe)
import Data.String (Pattern(..), split)
import Foreign (ForeignError)
import Orchestrator.Main (Command, Definition, makeCommand, makeDefinition)
import Simple.JSON as SimpleJSON

type JSONCommand = String
type JSONDefinition = { commands :: Array JSONCommand }

fromJSON' :: String -> JSONDefinition
fromJSON' text = either (const $ { commands: [] }) identity (decode text)
  where
    decode :: String -> Either (NonEmptyList ForeignError) JSONDefinition
    decode = SimpleJSON.readJSON

fromJSON :: String -> Definition
fromJSON json = makeDefinition commands
  where
    jsonDefinition :: JSONDefinition
    jsonDefinition = fromJSON' json

    commands :: Array Command
    commands = map stringToCommand jsonDefinition.commands

stringToCommand :: String -> Command
stringToCommand text = makeCommand program args
  where
    parts :: Array String
    parts = split (Pattern " ") text

    program :: String
    program = maybe "" identity (head parts)

    args :: Array String
    args = maybe [] identity (tail parts)
