{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified "common" ElmMarshall.Types as T
import           "ghcjs-ffiqq" GHCJS.Foreign.QQ
import           "ghcjs-base" GHCJS.Types ( JSVal, jsval )
import           "ghcjs-base" GHCJS.Marshal ( fromJSValUnchecked, toJSVal )
import qualified "ghcjs-base" GHCJS.Foreign.Callback as F
import qualified "ghcjs-base" JavaScript.Object as Obj
import           "ghcjs-base" JavaScript.Object.Internal (Object(..))

modifyPerson :: T.Person -> T.Person
modifyPerson p = T.Person (T.age p + 1337) (Just "This name is set from ghcjs")


personFromElm :: JSVal -> IO T.Person
personFromElm jsv = do
  let o = Object jsv
  rawAge <- Obj.getProp "age" o
  rawName <- Obj.getProp "name" o

  age <- fromJSValUnchecked rawAge
  name <- fromJSValUnchecked rawName

  return $ T.Person age name

personToElm :: T.Person -> IO JSVal
personToElm person = do
  obj <- Obj.create

  jsAge <- toJSVal $ T.age person
  jsName <- toJSVal $ T.name person

  Obj.setProp "age" jsAge obj
  Obj.setProp "name" jsName obj

  return $ jsval obj


requestPersonChange :: JSVal -> IO ()
requestPersonChange jsPerson = do
  person <- personFromElm jsPerson

  let modified = modifyPerson person
  print person
  print modified
  objModified <- personToElm modified
  sendSubscriptionObject "changedPerson" objModified

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
