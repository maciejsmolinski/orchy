module Test.HTTP.Client (main) where

import Control.Bind (discard)
import Data.Unit (Unit, unit)
import HTTP.Client (post)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (expectError, shouldReturn)

main :: Spec Unit
main = do
  describe "post" do
    it "should throw when endpoint is not available" do
      expectError (post "http://site/test" "")

    it "should succeed when endpoint is available" do
      (post "https://httpbin.org/post" "") `shouldReturn` unit
