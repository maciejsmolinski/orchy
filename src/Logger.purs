module Logger (log, error, quote, dump, line) where

import Prelude

import Data.String (Pattern(..), split)
import Data.Traversable (traverse_)
import Date (hhmmss, yyyymmdd)
import Effect (Effect)
import Effect.Console as Console

data Format
  = Log
  | Error
  | Dump

line :: Effect Unit
line = Console.log ""

log :: String -> Effect Unit
log = (withTimestamp >=> Console.log) <<< format Log

error :: String -> Effect Unit
error = (withTimestamp >=> Console.log) <<< format Error

dump :: String -> Effect Unit
dump = Console.log <<< format Dump

quote :: String -> Effect Unit
quote message =
  traverse_ (\x -> (withTimestamp >=> dump) $ "    " <> x) (split (Pattern "\n") message)

withTimestamp :: String -> Effect String
withTimestamp message = do
  date <- yyyymmdd
  hour <- hhmmss
  pure $ date <> " " <> hour <> " " <> message

format :: Format -> String -> String
format Log message
  = code "1"
    <> code "37"
    <> "log "
    <> code "0"
    <> code "90"
    <> message
    <> code "0"
format Error message
  = code "1"
    <> code "31"
    <> "err "
    <> code "0"
    <> code "90"
    <> message
    <> code "0"
format Dump message
  = code "38;5;241"
    <> message
    <> code "0"

code :: String -> String
code a = "\x1b[" <> a <> "m"
