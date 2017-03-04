import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Types as T
import Task

import Ports as P



main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model = T.Person


init : (Model, Cmd Msg)
init =
  ( { age = 3, name = Just "Foo Bar" }
  , Cmd.none
  )



-- UPDATE


type Msg
  = NewPerson T.Person
  | RequestPersonChange


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewPerson p ->
      (p, Cmd.none)
    RequestPersonChange ->
      (model, P.requestPersonChange model)



-- VIEW

printName : Model -> String
printName model =
  case model.name of
    Nothing -> "No name available!"
    Just name -> name

view : Model -> Html Msg
view model =
  div []
    [ p [] [ text "Person details:" ]
    , p [] [ text "age: ", text (toString model.age), br [] [], text "name: ", text (printName model) ]
    , button [ onClick RequestPersonChange ] [ text "Have GHCJS change this person" ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  P.changedPerson NewPerson
