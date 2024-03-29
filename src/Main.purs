module Main where

import Data.Either (Either(..))
import Effect (Effect)
import HTTP.Server as HTTPServer
import HTTP.Utils as HTTPUtils
import Logger as Logger
import Orchestrator.FS (readFile)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (makeId, makeSecret, runDefinitionWithIdAndSecret)
import Prelude
import System.Environment (readEnvInt)

main :: Effect Unit
main = do
  port <- readEnvInt "PORT" 8181
  configuration <- readFile "configuration.json"
  case configuration of
    (Left _) -> Logger.error "Failure reading configuration.json"
    (Right contents) -> do
      parsed <- pure $ fromJSON contents
      case parsed of
        (Left error) -> do
          Logger.error "Configuration file is not structured properly"
          Logger.quote error
        (Right definitions) -> do
          HTTPServer.startSync port $ \route -> do
            Logger.info $ "Incoming request " <> route
            when (HTTPUtils.pathname route == "/run") do
              runDefinitionWithIdAndSecret (makeId (HTTPUtils.param "definition" route)) (makeSecret (HTTPUtils.param "secret" route)) definitions
          Logger.log $ "Orchy server is running at http://localhost:" <> (show port)
          Logger.line
