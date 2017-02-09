-- | This module is compiled with GHC and generates an elm file.
module Main where

import qualified "elm-export" Elm as Elm
import "base" Data.Proxy (Proxy (..))
import qualified "this" Example.Types as T

-- | Proxy allows us to refer to the type
person :: Proxy T.Person
person = Proxy


-- sumtype :: Proxy T.SumType
-- sumtype = Proxy

-- | What the resulting Elm file should contain. Make sure the elm project has
-- packages NoRedInk/elm-decode-pipeline and krisajenkins/elm-exts installed.
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


    -- , Elm.toElmTypeSource sumtype
    -- , Elm.toElmEncoderSource sumtype
    -- , Elm.toElmDecoderSource sumtype
    ]

-- | Generates the elm files
main :: IO ()
main = Elm.specsToDir [spec] "."
