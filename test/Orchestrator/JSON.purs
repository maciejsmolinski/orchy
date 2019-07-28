module Test.Orchestrator.JSON (main) where

import Data.Either (Either(..), isLeft)
import Data.Function (($))
import Data.Unit (Unit)
import Orchestrator.JSON (fromJSON)
import Orchestrator.Main (makeCommand, makeDefinition, makeDefinitions, makeDir, makeId, makeSecret)
import Prelude (discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

correct :: String
correct = """[{ "id": "first", "secret": "secret", "dir": ".", "commands": ["git status"] }]"""

incorrect :: String
incorrect = """[{ "command": "git status" }]"""

main ::  Spec Unit
main = do
  describe "fromJSON" do
    it "should return early when provided with incorrect structure" do
      (isLeft $ fromJSON incorrect) `shouldEqual` true

    it "should return definitions when correct structure is provided" do
      fromJSON correct `shouldEqual` (Right $ makeDefinitions [makeDefinition (makeId "first") (makeSecret "secret") (makeDir ".") [ makeCommand "git" ["status"] ]])
