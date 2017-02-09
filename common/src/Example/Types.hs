{-# LANGUAGE CPP                  #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module Example.Types where

import qualified "elm-export" Elm as Elm
import "base" GHC.Generics
import "aeson" Data.Aeson (ToJSON(..), FromJSON(..))

-- | Example data structure copied from
-- https://github.com/krisajenkins/elm-export#readme
-- See its test folder for more advanced examples
data Person = Person
  { age  :: Int
  , name :: Maybe String
  }
  deriving (Show, Eq, Generic, Elm.ElmType)


-- | Some sum type. Currently disabled. See
-- https://github.com/krisajenkins/elm-export/issues/6
-- Also, this one won't have an instance of ElmMarshall. This is because sum
-- types aren't allowed to go through ports. It uses JSON instead, since
-- Javascript objects /are/ allowed through ports.

-- data SumType =
--     Foo
--   | Bar
--   | Baz
--   deriving (Show, Eq, Generic, Elm.ElmType, FromJSON, ToJSON)
