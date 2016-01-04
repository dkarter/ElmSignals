import Graphics.Element exposing (..)
import Keyboard
import Char

characters : Signal Char
characters =
  Signal.map Char.fromCode Keyboard.presses

keyAllowed : Char -> Bool
keyAllowed char =
  List.member char ['h', 'j', 'k', 'l', '\r']

filterKeyPresses : Signal Char
filterKeyPresses =
  Signal.filter keyAllowed ' ' characters

main : Signal Element
main =
  Signal.map show filterKeyPresses
