module Test.Main where

import Control.Bind (discard)
import Data.Function (($))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.HTTP.Client as HTTPClientSpec
import Test.Orchestrator.JSON as OrchestratorJSONSpec
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  OrchestratorJSONSpec.main
  HTTPClientSpec.main
