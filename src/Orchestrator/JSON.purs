module Orchestrator.JSON (fromJSON) where

import Data.Array (head, tail)
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Data.Function (identity, ($))
import Data.Functor (map)
import Data.List.NonEmpty (toList)
import Data.Maybe (maybe)
import Data.Monoid ((<>))
import Data.String (Pattern(..), split, trim)
import Foreign (MultipleErrors, renderForeignError)
import Orchestrator.Main (Command, Definition, Definitions, makeCommand, makeDefinition, makeDefinitions, makeDir, makeId, makeSecret)
import Simple.JSON as SimpleJSON

type JSONDefinition =
  { id :: String
  , secret :: String
  , dir :: String
  , commands :: Array String }

type JSONDefinitions = Array JSONDefinition

fromJSON :: String -> Either String Definitions
fromJSON text = case (SimpleJSON.readJSON text :: Either MultipleErrors JSONDefinitions) of
  (Left errors) -> Left $ messages errors
  (Right json) -> Right $ makeDefinitions $ map toDefinition json
 where
    messages :: MultipleErrors -> String
    messages errors = trim $ foldl (\a b -> a <> " " <> b) "" $ map renderForeignError $ toList errors

toDefinition :: JSONDefinition -> Definition
toDefinition definition = makeDefinition (makeId definition.id) (makeSecret definition.secret) (makeDir definition.dir) (map stringToCommand definition.commands)

stringToCommand :: String -> Command
stringToCommand text = makeCommand program args
  where
    parts :: Array String
    parts = split (Pattern " ") text

    program :: String
    program = maybe "" identity (head parts)

    args :: Array String
    args = maybe [] identity (tail parts)
