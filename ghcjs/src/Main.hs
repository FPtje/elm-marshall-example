{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified "common" ElmMarshall.Types as T
import qualified "elm-marshall" Elm.Marshall as Elm
import           "ghcjs-ffiqq" GHCJS.Foreign.QQ
import           "ghcjs-base" GHCJS.Types ( JSVal, jsval )
import           "ghcjs-base" GHCJS.Marshal ( fromJSValUnchecked, toJSVal )
import qualified "ghcjs-base" GHCJS.Foreign.Callback as F
import qualified "ghcjs-base" JavaScript.Object as Obj
import           "ghcjs-base" JavaScript.Object.Internal (Object(..))

-- | Simple function to modify the person
modifyPerson :: T.Person -> T.Person
modifyPerson p = T.Person (T.age p + 1337) (Just "This name is set from ghcjs")

-- | This function is bound to the requestPersonChange port in Elm in the main
-- function. It simply changes the person and sends it back to elm through the
-- changedPerson subscription
requestPersonChange :: Elm.ElmApp -> T.Person -> IO ()
requestPersonChange app person = do
    putStrLn $ "Received person: " ++ show person
    Elm.sendSubscriptionObject app "changedPerson" $ modifyPerson person

-- | Main function. 
-- Just gets the Elm app from a global and binds a listener to the requestPersonChange port
main :: IO ()
main = do
    app <- Elm.fromGlobalApp "app"
    Elm.assignPortListener app "requestPersonChange" (requestPersonChange app)
