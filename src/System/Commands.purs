module System.Commands (asyncExec) where

import Data.Either (Either(..))
import Data.Function.Uncurried (Fn7, runFn7)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff, Canceler, Error, makeAff, nonCanceler)

type Options = { cwd :: String }
type Program = String
type Args = Array String
type Success = String
type Failure = String

type Result = Either Failure Success

foreign import asyncExec_
  :: Fn7
  (Success -> Result)
  (Failure -> Result)
  Canceler
  (Either Error Result -> Effect Unit)
  Program
  Args
  Options
  (Effect Canceler)

asyncExec :: Program -> Args -> Options -> Aff Result
asyncExec program args options = makeAff \cb -> runFn7 asyncExec_ Right Left nonCanceler cb program args options
