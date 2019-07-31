module Main where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Foreign (MultipleErrors)
import HTTP.Server as HTTPServer
import HTTP.Utils as HTTPUtils
import Logger as Logger
import Node.Process (lookupEnv)
import Orchestrator.FS (readFile)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (makeId, makeSecret, runDefinitionWithId, runDefinitionWithIdAndSecret)
import Simple.JSON (readJSON)

getPort :: Effect Int
getPort = do
  maybePort <- lookupEnv "PORT"
  case maybePort of
    Nothing -> pure 8181
    (Just portString) -> do
      case (readJSON portString :: Either MultipleErrors Int) of
        (Left _) -> pure 8181
        (Right port) -> pure port

main :: Effect Unit
main = do
  port <- getPort
  configuration <- readFile "configuration.json"
  case configuration of
    (Left _) -> Logger.error "Failure reading configuration.json"
    (Right contents) -> do
      parsed <- pure $ fromJSON contents
      case parsed of
        (Left error) -> Logger.error $ "Configuration file is not structured properly" <> "\n" <> error
        (Right definitions) -> do
          HTTPServer.startSync port $ \route -> do
            Logger.log $ "Incoming request " <> route
            when (HTTPUtils.pathname route == "/run") do
              runDefinitionWithIdAndSecret (makeId (HTTPUtils.param "definition" route)) (makeSecret (HTTPUtils.param "secret" route)) definitions
          Logger.log $ "Orchy server is running on http://localhost:" <> (show port)
