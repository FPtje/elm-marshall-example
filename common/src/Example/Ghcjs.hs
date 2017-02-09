{-# LANGUAGE StandaloneDeriving   #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module Example.Ghcjs where

import qualified "elm-export" Elm as Elm
import "this" Example.Types
import "elm-marshall" Elm.Marshall

deriving instance ElmMarshall Person
