module System.Commands (syncExec, asyncExec) where

import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, Fn7, runFn2, runFn7)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff, Canceler, Error, makeAff, nonCanceler)

type Options = { cwd :: String }
type Program = String
type Args = Array String
type Success = String
type Failure = String

type Result = Either Failure Success

foreign import syncExec_
  :: Fn2
     (Success -> Result)
     (Failure -> Result)
     (Fn2 Program Args (Effect Result))

syncExec :: Program -> Args -> Effect Result
syncExec = runFn2 (runFn2 syncExec_ Right Left)

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
