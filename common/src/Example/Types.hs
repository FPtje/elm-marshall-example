{-# LANGUAGE CPP                  #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module Example.Types where

import qualified "elm-export" Elm as Elm
import "base" GHC.Generics
import "aeson" Data.Aeson (ToJSON(..), FromJSON(..))

-- Test cases from elm-export
data Person = Person
  { age  :: Int
  , name :: Maybe String
  }
  deriving (Show, Eq, Generic, Elm.ElmType)

data Position
  = Beginning
  | Middle
  | End
  deriving (Generic, Elm.ElmType)

data Timing
  = Start
  | Continue Double
  | Stop
  deriving (Generic, Elm.ElmType)

data Monstrosity
  = NotSpecial
  | OkayIGuess Monstrosity
  | Ridiculous Int String [Monstrosity]
  deriving (Generic, Elm.ElmType)
