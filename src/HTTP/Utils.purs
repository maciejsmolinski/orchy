module HTTP.Utils (pathname, Path, param) where

import Data.Function.Uncurried (Fn2, runFn2)

type Param = String
type Path = String

foreign import pathname :: Path -> String

foreign import param_
  :: Fn2
     Param
     Path
     String

param :: Param -> Path -> String
param = runFn2 param_
