module Orchestrator.Main (makeId, makeSecret, makeDir, makeCommand, makeDefinition, makeDefinitions, runDefinition, runDefinitionWithId, Definitions, Definition, Command, Id, Secret, Dir) where

import Control.Applicative (pure)
import Control.Bind (bind, discard, (>>=))
import Control.Monad.Error.Class (try)
import Data.Array (find, (:))
import Data.Either (Either(..))
import Data.Eq (class Eq, (==))
import Data.Foldable (foldl)
import Data.Function (($))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(..))
import Data.Semigroup ((<>))
import Data.Show (class Show)
import Data.Traversable (traverse_)
import Data.Unit (Unit, unit)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_, message)
import Effect.Class (liftEffect)
import Logger as Logger
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

runDefinitionWithId :: Id -> Definitions -> Effect Unit
runDefinitionWithId selectedId@(Id id) (Definitions { definitions }) = do
  case maybeDefinition of
    Nothing -> do
      Logger.error $ "Definition with id \"" <> id <> "\" not found"
    (Just definition) -> do
      Logger.log $ "Running definition \"" <> id <> "\""
      runDefinition definition
  where
    maybeDefinition :: Maybe Definition
    maybeDefinition = find (\(Definition { id: definitionId }) -> definitionId == selectedId) definitions

runDefinition :: Definition -> Effect Unit
runDefinition (Definition { dir, commands }) = execCommands dir commands
  where
    showPretty :: Array String -> String
    showPretty args = foldl (\a b -> a <> " " <> b) "" args

    annotate :: Command -> Aff Command
    annotate command@(Command program args) = do
      liftEffect $ Logger.log $ "Executing" <> (showPretty (program : args))
      pure command

    run :: Dir -> Command -> Aff String
    run (Dir cwd) (Command program args) = asyncExec program args { cwd }

    logOutput :: String -> Aff Unit
    logOutput value = do
      liftEffect $ Logger.dump value
      liftEffect $ Logger.line

    execCommands :: Dir -> Array Command -> Effect Unit
    execCommands cwd items =
      launchAff_ do
        result <- try $ traverse_ (\command -> (annotate command) >>= run cwd >>= logOutput) items
        case result of
          (Left a) -> do
            liftEffect $ Logger.dump $ message a
            liftEffect $ Logger.line
            liftEffect $ Logger.error "Execution FAILED"
          (Right _) -> do
            liftEffect $ Logger.log "Execution SUCCEEDED"
        pure unit
