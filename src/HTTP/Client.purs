module HTTP.Client where

import Data.Function.Uncurried (Fn2, runFn2)
import Data.Unit (Unit)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

type URL = String
type Payload = String

foreign import post_
  :: Fn2
     URL
     Payload
     (EffectFnAff Unit)

post :: URL -> Payload -> Aff Unit
post url payload = fromEffectFnAff (runFn2 post_ url payload)
