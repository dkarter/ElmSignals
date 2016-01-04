import Graphics.Element exposing (..)
import Keyboard
import Mouse
import Char
import String

state : Signal String
state =
  Signal.foldp appendKey "" Keyboard.presses

appendKey : Int -> String -> String
appendKey keyCode chars =
  keyCode
    |> Char.fromCode
    |> String.fromChar
    |> String.append chars

main : Signal Element
main =
  Signal.map show state
