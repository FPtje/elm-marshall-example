port module Ports exposing (..)

import Types as T

port requestPersonChange : T.Person -> Cmd msg

port changedPerson : (T.Person -> msg) -> Sub msg
