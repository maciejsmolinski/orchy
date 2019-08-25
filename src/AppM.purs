module AppM where

import Capabilities.Env (class HasEnv)
import Capabilities.Logger (class HasLogger)
import Control.Applicative (class Applicative)
import Control.Apply (class Apply)
import Control.Bind (class Bind)
import Control.Monad (class Monad)
import Data.Function (($), (<<<))
import Data.Functor (class Functor)
import Data.Newtype (class Newtype)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Logger as Logger
import System.Environment (readEnvInt)

newtype AppM a = AppM (Aff a)

derive instance newtypeAppM :: Newtype (AppM a) _
derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffM :: MonadAff AppM

instance hasLoggerAppM :: HasLogger AppM where
  log :: String -> AppM Unit
  log = liftEffect <<< Logger.log

instance hasEnvAppM :: HasEnv AppM where
  getEnvInt :: String -> Int -> AppM Int
  getEnvInt variable defaultValue = liftEffect $ readEnvInt variable defaultValue

runApp :: forall a. AppM a -> Effect Unit
runApp (AppM aff) = launchAff_ aff
