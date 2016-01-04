import Graphics.Element exposing (..)
import Mouse
import Window
import Keyboard
import Time

main =
  -- Time.every Time.second
  --   |> Signal.map show
  -- Signal.map show Window.dimensions
  -- Signal.map show Mouse.position
  -- Signal.map show Keyboard.arrows
  -- Signal.map show Keyboard.keysDown
  -- Signal.map show Keyboard.presses
  Signal.map show <| Signal.map2 Keyboard.enter Keyboard.presses


