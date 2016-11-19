module ElmMarshall.Types where

import qualified "elm-export" Elm as Elm
import "base" GHC.Generics

-- | Example data structure copied from
-- https://github.com/krisajenkins/elm-export#readme
-- See its test folder for more advanced examples
data Person = Person
  { age  :: Int
  , name :: Maybe String
  }
  deriving (Show, Eq, Generic, Elm.ElmType)
