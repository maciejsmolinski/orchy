module Logger (log, error, dump) where

import Prelude

import Effect (Effect)
import Effect.Console as Console

data Format
  = Log
  | Error
  | Dump

log :: String -> Effect Unit
log = Console.log <<< format Log

error :: String -> Effect Unit
error = Console.log <<< format Error

dump :: String -> Effect Unit
dump = Console.log <<< format Dump

format :: Format -> String -> String
format Log message
  = code "1"
    <> code "37"
    <> "[Log] "
    <> code "0"
    <> code "90"
    <> message
    <> code "0"
format Error message
  = code "1"
    <> code "31"
    <> "[Err] "
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
