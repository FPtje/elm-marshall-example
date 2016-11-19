module Main where

import qualified "elm-export" Elm as Elm
import "base" Data.Proxy (Proxy (..))
import qualified "this" ElmMarshall.Types as T

-- | Proxy allows us to refer to the type
person :: Proxy T.Person
person = Proxy

-- | What the resulting Elm file should contain
spec :: Elm.Spec
spec =
  Elm.Spec
    -- Module name:
    ["Types"]

    -- Contents:
    [ "import Json.Decode exposing (..)"
    , "import Json.Decode.Pipeline exposing (..)"
    , "import Json.Encode"
    , Elm.toElmTypeSource person
    , Elm.toElmEncoderSource person
    , Elm.toElmDecoderSource person
    ]

-- | Generates the elm files
main :: IO ()
main = Elm.specsToDir [spec] "."
