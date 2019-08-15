module Orchestrator.Main (makeId, makeSecret, makeDir, makeCommand, makeDefinition, makeDefinitions, runDefinition, runDefinitionWithIdAndSecret, Definitions, Definition, Command, Id, Secret, Dir) where

import Control.Bind (bind, discard)
import Control.Monad.Error.Class (try)
import Data.Array (find, (:))
import Data.Either (Either(..))
import Data.Eq (class Eq, (==))
import Data.Function (($), (<<<))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(..))
import Data.Semigroup ((<>))
import Data.Show (class Show)
import Data.String (joinWith)
import Data.Traversable (traverse_)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff, Error, launchAff_, message)
import Effect.Class (liftEffect)
import Logger as Logger
import Notifications.Slack as Slack
import Prelude ((&&), (*>))
import System.Commands (asyncExec)

type Program = String
type Args = Array String
newtype Id = Id String
newtype Secret = Secret String
newtype Dir = Dir String
data Command = Command Program Args

data Definition = Definition { id :: Id
                             , secret :: Secret
                             , dir :: Dir
                             , commands :: Array Command
                             }

data Definitions = Definitions { definitions :: Array Definition
                               }

derive instance genericId :: Generic Id _

derive instance genericSecret :: Generic Secret _

derive instance genericDir :: Generic Dir _

derive instance genericCommand :: Generic Command _

derive instance genericDefinition :: Generic Definition _

derive instance genericDefinitions :: Generic Definitions _

instance showId :: Show Id where
  show = genericShow

instance showSecret :: Show Secret where
  show = genericShow

instance showDir :: Show Dir where
  show = genericShow

instance showCommand :: Show Command where
  show = genericShow

instance showDefinition :: Show Definition where
  show = genericShow

instance showDefinitions :: Show Definitions where
  show = genericShow

instance eqId :: Eq Id where
  eq = genericEq

instance eqSecret :: Eq Secret where
  eq = genericEq

instance eqDir :: Eq Dir where
  eq = genericEq

instance eqCommand :: Eq Command where
  eq = genericEq

instance eqDefinition :: Eq Definition where
  eq = genericEq

instance eqDefinitions :: Eq Definitions where
  eq = genericEq

makeId :: String -> Id
makeId id = Id id

makeSecret :: String -> Secret
makeSecret secret = Secret secret

makeDir :: String -> Dir
makeDir dir = Dir dir

makeCommand :: Program -> Args -> Command
makeCommand program args = Command program args

makeDefinition :: Id -> Secret -> Dir -> Array Command -> Definition
makeDefinition id secret dir commands = Definition { id, secret, dir, commands }

makeDefinitions :: Array Definition -> Definitions
makeDefinitions definitions = Definitions { definitions }

runDefinitionWithIdAndSecret :: Id -> Secret -> Definitions -> Effect Unit
runDefinitionWithIdAndSecret selectedId@(Id id) selectedSecret (Definitions { definitions }) = do
  case maybeDefinition of
    Nothing -> do
      Logger.error $ "Definition with provided id and secret not found"
    (Just definition) -> do
      Logger.info $ "Running definition \"" <> id <> "\""
      runDefinition definition
  where
    maybeDefinition :: Maybe Definition
    maybeDefinition = find (\(Definition { id: definitionId, secret: definitionSecret }) -> definitionId == selectedId && definitionSecret == selectedSecret) definitions

runDefinition :: Definition -> Effect Unit
runDefinition (Definition { dir, commands }) = launchAff_ do
  result <- try $ traverse_ (executeCommand dir) commands
  case result of
    (Left output) -> logOutput output *> logFailure
    (Right _) -> logSuccess
  where
    logFailure :: Aff Unit
    logFailure = do
      liftEffect $ Logger.error "Execution FAILED"
      Slack.notify "Execution FAILED"

    logSuccess :: Aff Unit
    logSuccess = do
      liftEffect $ Logger.info "Execution SUCCEEDED"
      Slack.notify "Execution SUCCEEDED"

    logOutput :: Error -> Aff Unit
    logOutput error = do
      liftEffect <<< Logger.quote $ message error
      Slack.notify $ message error

    executeCommand :: Dir -> Command -> Aff Unit
    executeCommand (Dir cwd) (Command program args) = do
      liftEffect $ Logger.info $ "Executing " <> (joinWith " " (program : args))
      Slack.notify $ "Executing " <> (joinWith " " (program : args))
      output <- asyncExec program args { cwd }
      liftEffect $ Logger.quote output
      Slack.notify output
