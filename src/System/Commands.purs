module System.Commands (syncExec) where

import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, runFn2)
import Effect (Effect)

type Program = String
type Args = Array String
type Success = String
type Error = String

type Result = Either Error Success

foreign import syncExec_
  :: Fn2
     (Success -> Result)
     (Error -> Result)
     (Fn2 Program Args (Effect Result))

syncExec :: Program -> Args -> Effect Result
syncExec = runFn2 (runFn2 syncExec_ Right Left)
