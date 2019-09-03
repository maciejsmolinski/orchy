module Main where

import Control.Monad.Except.Trans (ExceptT(..), runExceptT, withExceptT)
import Data.Either (Either(..))
import Effect (Effect)
import HTTP.Server as HTTPServer
import HTTP.Utils as HTTPUtils
import Logger as Logger
import Orchestrator.FS (readFile)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (Definitions, makeId, makeSecret, runDefinitionWithIdAndSecret)
import Prelude
import System.Environment (readEnvInt)

readConfiguration :: ExceptT String Effect String
readConfiguration =
  withExceptT
  (const "Failure reading configuration.json")
  (ExceptT $ readFile "configuration.json")

parseConfiguration :: String -> ExceptT String Effect Definitions
parseConfiguration string =
  withExceptT
  (\lines -> "Configuration file is not structured properly" <> "\n" <> lines)
  (ExceptT $ pure $ fromJSON string)

getConfiguration :: Effect (Either String Definitions)
getConfiguration = runExceptT $ readConfiguration >>= parseConfiguration

main :: Effect Unit
main = do
  port <- readEnvInt "PORT" 8181
  configuration <- getConfiguration
  case configuration of
    (Left msg) -> Logger.error msg
    (Right definitions) -> do
      HTTPServer.startSync port $ \route -> do
        Logger.info $ "Incoming request " <> route
        when (HTTPUtils.pathname route == "/run") do
          runDefinitionWithIdAndSecret (makeId (HTTPUtils.param "definition" route)) (makeSecret (HTTPUtils.param "secret" route)) definitions
      Logger.log $ "Orchy server is running at http://localhost:" <> (show port)
      Logger.line
