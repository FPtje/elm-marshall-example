{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified "common" Example.Types as T

-- Only import the ElmMarshall instances from Example.Ghcjs
import qualified "common" Example.Ghcjs ()
import qualified "elm-marshall" Elm.Marshall as Elm

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

positionFromElm :: Elm.ElmApp -> T.Position -> IO ()
positionFromElm app pos = do
    putStrLn $ "Received pos: " ++ show pos

    Elm.sendJSONSubscriptionObject app "positionIn" T.Middle
    putStrLn "Sent position"

timingFromElm :: Elm.ElmApp -> T.Timing -> IO ()
timingFromElm app timing = do
    putStrLn $ "Received timing: " ++ show timing

    Elm.sendJSONSubscriptionObject app "timingIn" $ T.Continue 2
    putStrLn "Sent timing"

monstrosityFromElm :: Elm.ElmApp -> T.Monstrosity -> IO ()
monstrosityFromElm app monstrosity = do
    putStrLn $ "Received monstrosity: " ++ show monstrosity

    Elm.sendJSONSubscriptionObject app "monstrosityIn" $
      T.Ridiculous 2 "from ghcjs"
        [ T.Ridiculous 3 "from ghcjs too" []
        , T.Ridiculous 4 "also from ghcjs" []
        ]

    putStrLn "Sent monstrosity"


-- | Main function. Just gets the Elm app from a global and binds some
-- listeners to the requestPersonChange port
main :: IO ()
main = do
    app <- Elm.fromGlobalApp "app"

    Elm.assignPortListener
        app
        "requestPersonChange"
        (requestPersonChange app)

    Elm.assignJSONPortListener
        app
        "positionOut"
        (positionFromElm app)

    Elm.assignJSONStringPortListener
        app
        "timingOut"
        (timingFromElm app)

    Elm.assignJSONStringPortListener
        app
        "monstrosityOut"
        (monstrosityFromElm app)

