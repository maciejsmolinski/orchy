module Logger (info, error, quote, log, line) where

import Prelude

import Data.String (Pattern(..), split)
import Data.Traversable (traverse_)
import Date (hhmmss, yyyymmdd)
import Effect (Effect)
import Effect.Console as Console

data Format
  = Info
  | Error
  | Log
  | Empty

logWithTimestamp :: String -> Effect Unit
logWithTimestamp = withTimestamp >=> Console.log

withTimestamp :: String -> Effect String
withTimestamp message = do
  date <- yyyymmdd
  hour <- hhmmss
  pure $ dim <> date <> " " <> hour <> clear <> " " <> message

lines :: String -> Array String
lines = split (Pattern "\n")

line :: Effect Unit
line = Console.log ""

log :: String -> Effect Unit
log = Console.log <<< format Log

info :: String -> Effect Unit
info = (traverse_ (logWithTimestamp <<< format Info)) <<< lines

error :: String -> Effect Unit
error = (traverse_ (logWithTimestamp <<< format Error)) <<< lines

quote :: String -> Effect Unit
quote = (traverse_ (logWithTimestamp <<< format Empty)) <<< lines

format :: Format -> String -> String
format Info message = bold <> blue <> "info " <> clear <> message <> clear
format Error message = bold <> red <> "err  " <> clear <> message <> clear
format Log message = dim <> message <> clear
format Empty message = "     " <> dim <> message <> clear

code :: String -> String
code a = "\x1b[" <> a <> "m"

red :: String
red = code "31"

blue :: String
blue = code "34"

bold :: String
bold = code "1"

dim :: String
dim = code "2"

clear :: String
clear = code "0"
