module Main where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import HTTP.Server as HTTPServer
import HTTP.Utils as HTTPUtils
import Logger as Logger
import Orchestrator.FS (readFile)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (makeId, runDefinitionWithId)

main :: Effect Unit
main = do
  configuration <- readFile "configuration.json"
  case configuration of
    (Left _) -> Logger.error "Failure reading configuration.json"
    (Right contents) -> do
      parsed <- pure $ fromJSON contents
      case parsed of
        (Left error) -> Logger.error $ "Configuration file is not structured properly" <> "\n" <> error
        (Right definitions) -> do
          HTTPServer.startSync 8181 $ \route -> do
            Logger.line
            Logger.line
            Logger.log $ "[HTTP/GET] " <> route
            when (HTTPUtils.pathname route == "/run") do
              Logger.line
              runDefinitionWithId (makeId (HTTPUtils.param "definition" route)) definitions
          Logger.log $ "Orchy server is running on http://localhost:8181"
