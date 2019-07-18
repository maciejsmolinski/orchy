module Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Orchestrator.Main (Definition, makeCommand, makeDefinition, runDefinition)
import System.Commands (asyncExec, syncExec)

main :: Effect Unit
main = do
  log "Orchestrator.Main.runDefinition/start"
  runDefinition definition
  log "Orchestrator.Main.runDefinition/end"

  log "---"

  log "System.Commands.syncExec/start"
  syncExec "pwd" [] >>= logOutput
  log "System.Commands.syncExec/end"

  log "---"

  launchAff_ do
    liftEffect $ log "System.Commands.asyncExec/start"
    asyncExec "pwd" [] >>= (liftEffect <<< logOutput)
    liftEffect $ log "System.Commands.asyncExec/end"

  where
    logOutput output = log $ "-> " <> (show output)



definition :: Definition
definition = makeDefinition $ [ makeCommand "git" ["status"]
                              , makeCommand "echo" ["\"done\""]
                              ]
