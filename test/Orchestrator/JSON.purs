module Test.Orchestrator.JSON (main) where

import Data.Unit (Unit)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

main ::  Spec Unit
main = do
  describe "fromJSON" do
    it "should work" do
      true `shouldEqual` true
