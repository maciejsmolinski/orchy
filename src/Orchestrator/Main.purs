module Orchestrator.Main (makeCommand, makeDefinition, runDefinition, Definition, Command) where

import Data.Array ((:))
import Data.Foldable (foldl)
import Data.Function (($), (<<<))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Semigroup ((<>))
import Data.Show (class Show)
import Data.Traversable (traverse_)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Console (log)

type Program = String
type Args = Array String

data Command = Command Program Args

data Definition = Definition { commands :: Array Command
                             }

derive instance genericCommand :: Generic Command _

derive instance genericDefinition :: Generic Definition _

instance showCommand :: Show Command where
  show = genericShow

instance showDefinition :: Show Definition where
  show = genericShow

makeCommand :: Program -> Args -> Command
makeCommand program args = Command program args

makeDefinition :: Array Command -> Definition
makeDefinition commands = Definition { commands }

runDefinition :: Definition -> Effect Unit
runDefinition (Definition { commands }) = traverse_ execute commands
  where
    print :: String -> Effect Unit
    print = log <<< ((<>) "->")

    execute :: Command -> Effect Unit
    execute (Command program args) = print <<< showPretty $ program : args

    showPretty :: Array String -> String
    showPretty args = foldl (\a b -> a <> " " <> b) "" args
