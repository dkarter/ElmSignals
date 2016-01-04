import Html exposing (..)
import Html.Events exposing (..)

-- MODEL
type alias Model = String

initialModel : String
initialModel =
  "Waiting..."

-- UPDATE
type Action = NoOp | English | French | Reset

update action text =
  case action of
    English -> "Language is English now"
    French -> "Language is French now"
    Reset -> "- - - -"
    NoOp -> text

-- VIEW
view : Signal.Address Action -> String -> Html
view address greeting =
  div []
    [ button [ onClick address English ] [ text "Hello!" ]
    , button [ onClick address French ] [ text "Salut!" ]
    , button [ onClick address Reset ] [ text "Reset" ]
    , p [ ] [ text greeting ]
    ]

-- SIGNALS
actionsMailbox : Signal.Mailbox Action
actionsMailbox =
  Signal.mailbox NoOp

state =
  Signal.foldp update initialModel actionsMailbox.signal

main : Signal Html
main =
  Signal.map (view actionsMailbox.address) state
