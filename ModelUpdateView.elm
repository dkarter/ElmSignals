import Graphics.Element exposing (..)
import Keyboard
import Mouse


-- MODEL
type alias Model = Int

initialModel : Model
initialModel = 1

-- UPDATE
update : Int -> Model -> Model
update event model =
  model * event

-- VIEW
view : Model -> Graphics.Element.Element
view model =
  show model

-- Main & State
state : Signal Int
state =
  Signal.foldp update initialModel Keyboard.presses

main : Signal Element
main =
  Signal.map view state
