module Orchestrator.FS (read) where

import Data.Either (Either(..))
import Data.Function.Uncurried (Fn3, runFn3)
import Effect (Effect)

type FilePath = String
type Failure = String
type Success = String
type Result = Either Failure Success

foreign import readFile_
  :: Fn3
  (Failure -> Result)
  (Success -> Result)
  FilePath
  (Effect Result)

read :: FilePath -> Effect Result
read path = runFn3 readFile_ Left Right path
