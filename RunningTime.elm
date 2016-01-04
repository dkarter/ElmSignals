import Graphics.Element exposing (..)
import Time

runningTime : Signal Int
runningTime =
  Signal.foldp (\_ count -> count + 1) 0 (Time.every Time.second)

main =
  Signal.map show runningTime
