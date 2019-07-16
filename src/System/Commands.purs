module Commands (exec) where

import Data.Function.Uncurried (Fn2, runFn2)
import Data.Unit (Unit)
import Effect (Effect)

type Program = String
type Args = Array String

foreign import execFn :: Fn2 Program Args (Effect Unit)

exec :: Program -> Args -> Effect Unit
exec = runFn2 execFn
