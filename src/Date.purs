module Date (ddmmyyyy, yyyymmdd, hhmmss) where

import Effect (Effect)

foreign import ddmmyyyy :: Effect String

foreign import yyyymmdd :: Effect String

foreign import hhmmss :: Effect String
