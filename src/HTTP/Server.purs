module HTTP.Server (startSync, startAsync) where

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import Prelude (Unit, (<<<))

type Port = Int
type Route = String

foreign import startSync_
  :: EffectFn2
     Port
     (Route -> Effect Unit)
     Unit

foreign import startAsync_
  :: Port
  -> EffectFnAff Route

startSync :: Port -> (Route -> Effect Unit) -> Effect Unit
startSync = runEffectFn2 startSync_

startAsync :: Port -> Aff Route
startAsync = (fromEffectFnAff <<< startAsync_)
