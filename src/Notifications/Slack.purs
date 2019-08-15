module Notifications.Slack (notify) where

import Control.Applicative (pure)
import Control.Monad (bind)
import Data.Function (($))
import Data.Monoid ((<>))
import Data.Tuple (Tuple(..))
import Data.Unit (Unit, unit)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import HTTP.Client (post)
import Simple.JSON (writeJSON)
import System.Environment (readEnvString)

notify :: String -> Aff Unit
notify message = do
  slackHookUrl <- liftEffect $ readEnvString "SLACK_HOOK_URL" ""
  slackChannel <- liftEffect $ readEnvString "SLACK_CHANNEL" ""
  case (Tuple slackHookUrl slackChannel) of
       (Tuple "" _) -> pure unit
       (Tuple _ "") -> pure unit
       (Tuple url channel) -> do
         post url payload
           where
             payload = writeJSON $ { channel: "#" <> channel
                                   , username: "orchy"
                                   , icon_emoji: ":juggling:"
                                   , text: message
                                   }
