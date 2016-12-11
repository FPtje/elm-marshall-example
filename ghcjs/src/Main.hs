{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import qualified "common" ElmMarshall.Types as T
import "ghcjs-ffiqq" GHCJS.Foreign.QQ
import "ghcjs-base" GHCJS.Types ( JSVal, jsval )
import "ghcjs-base" GHCJS.Marshal ( fromJSValUnchecked )
import qualified "ghcjs-base" GHCJS.Foreign.Callback as F

modifyPerson :: T.Person -> T.Person
modifyPerson p = T.Person (T.age p + 1337) (Just "This name is set from ghcjs")


requestPersonChange :: JSVal -> IO ()
requestPersonChange jsPerson = do
  undefined
  -- sendSubscriptionObject "changedPerson" <TODO>

assignPortListener :: String -> F.Callback a -> IO ()
assignPortListener portName callback =
    let callback1 = jsval callback
    in [jsi_| app.ports[ `portName ].subscribe( `callback1 ); |]


sendSubscriptionObject :: String -> JSVal -> IO ()
sendSubscriptionObject portName value = [js_| app.ports[ `portName ].send( `value ); |]

main :: IO ()
main = do
    portPersonChange <-
      F.asyncCallback1 requestPersonChange

    assignPortListener "requestPersonChange" portPersonChange
