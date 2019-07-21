module Orchestrator.Main (makeCommand, makeDefinition, runDefinition, Definition, Command) where

import Control.Applicative (pure)
import Control.Bind (bind, discard, (>>=))
import Control.Monad.Error.Class (try)
import Data.Array ((:))
import Data.Either (Either(..))
import Data.Eq (class Eq)
import Data.Foldable (foldl)
import Data.Function (($))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Semigroup ((<>))
import Data.Show (class Show, show)
import Data.Traversable (traverse_)
import Data.Unit (Unit, unit)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import System.Commands (asyncExec)

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

instance eqCommand :: Eq Command where
  eq = genericEq

instance eqDefinition :: Eq Definition where
  eq = genericEq

makeCommand :: Program -> Args -> Command
makeCommand program args = Command program args

makeDefinition :: Array Command -> Definition
makeDefinition commands = Definition { commands }

runDefinition :: Definition -> Effect Unit
runDefinition (Definition { commands }) = execCommands commands
  where
    showPretty :: Array String -> String
    showPretty args = foldl (\a b -> a <> " " <> b) "" args

    annotate :: Command -> Aff Command
    annotate command@(Command program args) = do
      liftEffect $ log $ "* Running" <> (showPretty (program : args))
      pure command

    run :: Command -> Aff (Either String String)
    run (Command program args) = asyncExec program args

    logOutput :: Either String String -> Aff Unit
    logOutput value = liftEffect $ log $ "-> " <> (show value)

    execCommands :: Array Command -> Effect Unit
    execCommands items =
      launchAff_ do
        liftEffect $ log "Executing"
        result <- try $ traverse_ (\command -> (annotate command) >>= run >>= logOutput) items
        case result of
          (Left _) -> (liftEffect $ log "Execution FAILED")
          (Right _) -> (liftEffect $ log "Execution SUCCEEDED")
        pure unit
