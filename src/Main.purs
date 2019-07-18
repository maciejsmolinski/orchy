module Main where

import Prelude

import Effect (Effect)
import Orchestrator.Main (Definition, makeCommand, makeDefinition, runDefinition)

main :: Effect Unit
main = runDefinition definition

definition :: Definition
definition = makeDefinition [ makeCommand "pwd" []
                            , makeCommand "git" ["branch"]
                            , makeCommand "git" ["status"]
                            ]
