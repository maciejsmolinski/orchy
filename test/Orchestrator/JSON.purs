module Test.Orchestrator.JSON (main) where

import Data.Either (Either(..))
import Data.Function (($))
import Data.Unit (Unit)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (makeCommand, makeDefinition)
import Prelude (discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

correct :: String
correct = """{ "commands": ["git status"] }"""

incorrect :: String
incorrect = """{ "command": "git status" }"""

main ::  Spec Unit
main = do
  describe "fromJSON" do
    it "should return early when provided with incorrect structure" do
      fromJSON incorrect `shouldEqual` Left "Incorrect JSON structure provided"

    it "should return a definition when correct structure is provided" do
      fromJSON correct `shouldEqual` (Right $ makeDefinition [ makeCommand "git" ["status"] ])