import Graphics.Element exposing (..)
import Mouse
import Keyboard
import Window
import Char
import Set

type alias ShortcutKeys =
  { ctrl: Bool
  , alt: Bool
  , shift: Bool
  , super: Bool
  , keysDown : List Char
  }

combinedKeyboardSignals : Bool -> Bool -> Bool -> Bool -> Set.Set Char.KeyCode -> ShortcutKeys
combinedKeyboardSignals ctrl alt shift super keys =
  { ctrl = ctrl
  , alt = alt
  , shift = shift
  , super = super
  , keysDown = keysToCharacterList keys
  }

keysToCharacterList : Set.Set Char.KeyCode -> List Char
keysToCharacterList keyCodes =
  keyCodes
    |> Set.filter removeModifierKeys
    |> Set.toList
    |> List.map Char.fromCode

-- 91, 93 are left and right super keys
removeModifierKeys : Int -> Bool
removeModifierKeys keyCode =
  not (List.member keyCode [16,17,18,91,93])

keyboardPresses : Signal ShortcutKeys
keyboardPresses =
  Signal.map5 combinedKeyboardSignals Keyboard.ctrl Keyboard.alt Keyboard.shift Keyboard.meta Keyboard.keysDown

main : Signal Element
main =
  Signal.map show keyboardPresses
