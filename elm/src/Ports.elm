port module Ports exposing (..)

import Types as T

-- Sends the person to ghcjs
port requestPersonChange : T.Person -> Cmd msg

-- Gets a new person back from ghcjs
port changedPerson : (T.Person -> msg) -> Sub msg
