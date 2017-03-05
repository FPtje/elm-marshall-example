port module Ports exposing (..)

import Types as T
import Json.Encode exposing ( Value )

-- Sends the person to ghcjs
port requestPersonChange : T.Person -> Cmd msg

-- Gets a new person back from ghcjs
port changedPerson : (T.Person -> msg) -> Sub msg

-- elm-export test things
port positionOut    : Value -> Cmd msg
port timingOut      : String -> Cmd msg
port monstrosityOut : String -> Cmd msg


port positionIn     : (Value -> msg) -> Sub msg
port timingIn       : (Value -> msg) -> Sub msg
port monstrosityIn  : (Value -> msg) -> Sub msg
