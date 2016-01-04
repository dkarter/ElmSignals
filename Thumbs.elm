module Thumbs where

import Html exposing (..)
import Html.Events exposing (..)

-- MODEL

type alias Model =
  { ups : Int,
    downs : Int
  }


initialModel : Model
initialModel =
  { ups = 0,
    downs = 0
  }


-- UPDATE

type Action = NoOp | Up | Down


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    Up ->
      { model | ups = model.ups + 1 }
    Down ->
      { model | downs = model.downs + 1 }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Down ]
        [ text ((toString model.downs) ++ " Thumbs Down") ],
      button [ onClick address Up ]
        [ text ((toString model.ups) ++ " Thumbs Up") ],
      p [ ] [ text (toString <| rating model) ]
    ]

rating : Model -> Int
rating model =
  model.ups - model.downs

-- SIGNALS
actionsInbox : Signal.Mailbox Action
actionsInbox =
  Signal.mailbox NoOp

state : Signal Model
state =
  Signal.foldp update initialModel actionsInbox.signal

main : Signal Html
main =
  Signal.map (view actionsInbox.address) state

