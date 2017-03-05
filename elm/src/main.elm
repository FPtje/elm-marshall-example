import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as JsonE
import Json.Decode as JsonD
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


type alias Model =
  { person      : T.Person
  , position    : T.Position
  , timing      : T.Timing
  , monstrosity : T.Monstrosity
  }


init : (Model, Cmd Msg)
init =
  let
    model =
      { person      = { age = 3, name = Just "Foo Bar" }
      , position    = T.Beginning
      , timing      = T.Continue 1
      , monstrosity = T.OkayIGuess T.NotSpecial
      }
  in
  ( model
    -- Sadly, initial Cmds won't reach ghcjs, since the listeners are created
    -- after Elm has initialised.
  , Cmd.none
  )



-- UPDATE

unsafeFromResult : Result String val -> val
unsafeFromResult res =
    case res of
      Ok val -> val
      Err err -> Debug.crash err

type Msg
  = PersonUpdate T.Person
  | RequestPersonChange
  | ToGhcjs
  | ReceivePosition    JsonD.Value
  | ReceiveTiming      JsonD.Value
  | ReceiveMonstrosity JsonD.Value

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PersonUpdate p ->
      ({ model | person = p }, Cmd.none)

    RequestPersonChange ->
      (model, P.requestPersonChange model.person)

    ToGhcjs ->
      (model, Cmd.batch
        [ P.positionOut    <|                   T.encodePosition    model.position
        , P.timingOut      <| JsonE.encode 0 <| T.encodeTiming      model.timing
        , P.monstrosityOut <| JsonE.encode 0 <| T.encodeMonstrosity model.monstrosity
        ])

    ReceivePosition val ->
        ({ model | position    = unsafeFromResult <| JsonD.decodeValue T.decodePosition val }, Cmd.none)

    ReceiveTiming val ->
        ({ model | timing      = unsafeFromResult <| JsonD.decodeValue T.decodeTiming val }, Cmd.none)

    ReceiveMonstrosity val ->
        ({ model | monstrosity = unsafeFromResult <| JsonD.decodeValue T.decodeMonstrosity val }, Cmd.none)




-- VIEW

printName : T.Person -> String
printName person =
  case person.name of
    Nothing -> "No name available!"
    Just name -> name

view : Model -> Html Msg
view model =
  div []
    [ p [] [ text "Person details:" ]
    , p [] [ text "age: ", text (toString model.person.age), br [] [], text "name: ", text (printName model.person) ]
    , button [ onClick RequestPersonChange ] [ text "Have GHCJS change this person" ]

    , p [] [ text <| "position: " ++ toString model.position ]
    , p [] [ text <| "timing: " ++ toString model.timing ]
    , p [] [ text <| "monstrosity: " ++ toString model.monstrosity ]

    , button [ onClick ToGhcjs ] [ text "test" ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ P.changedPerson PersonUpdate
    , P.positionIn ReceivePosition
    , P.timingIn ReceiveTiming
    , P.monstrosityIn ReceiveMonstrosity
    ]
