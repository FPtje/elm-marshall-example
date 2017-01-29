{-# LANGUAGE CPP                  #-}
{-# LANGUAGE StandaloneDeriving   #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module ElmMarshall.Types where

import qualified "elm-export" Elm as Elm
import "base" GHC.Generics

#if defined(ghcjs_HOST_OS)
import "elm-marshall" Elm.Marshall
#endif

-- | Example data structure copied from
-- https://github.com/krisajenkins/elm-export#readme
-- See its test folder for more advanced examples
data Person = Person
  { age  :: Int
  , name :: Maybe String
  }
  deriving (Show, Eq, Generic, Elm.ElmType)


#if defined(ghcjs_HOST_OS)
deriving instance ElmMarshall Person
#endif
