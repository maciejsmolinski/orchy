module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Orchestrator.Main (Definition, makeCommand, makeDefinition, runDefinition)

main :: Effect Unit
main = do
  log "Orchestration started"
  runDefinition definition
  log "Orchestration done"


definition :: Definition
definition = makeDefinition $ [ makeCommand "git" ["status"]
                              , makeCommand "echo" ["\"done\""]
                              ]
