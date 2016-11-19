module Main where

import qualified "common" ElmMarshall.Types as T
import "ghcjs-ffiqq" GHCJS.Foreign.QQ

modifyPerson :: T.Person -> T.Person
modifyPerson p = T.Person (T.age p + 1337) (Just "This name is set from ghcjs")


main :: IO ()
main = putStrLn "yes"
