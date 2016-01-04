module Spaceship where

import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)

import Keyboard
import Window
import Time


-- MODEL

type alias Model =
  { position: Int
  , powerLevel: Int
  , isFiring: Bool
  , firedMissles: List Missle
  , gameWidth: Int
  , gameHeight: Int
  }

type alias Missle =
  { x: Float
  , y: Float
  }

initialShip : Model
initialShip  =
  { position = 0
  , powerLevel = 10
  , isFiring = False
  , firedMissles = []
  , gameWidth = 300
  , gameHeight = 300
  }


-- UPDATE
type Action =
  NoOp
  | Left
  | Right
  | Fire Bool
  | Tick
  | PropelMissle
  | DimensionsChanged (Int, Int)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    Right ->
      let
        boundry =
          model.gameWidth // 2 - 30
        newPosition =
          min boundry (model.position + 1)
      in
        { model | position = newPosition }

    Left ->
      let
        boundry =
          model.gameWidth // -2 + 30
        newPosition =
          max boundry (model.position - 1)
      in
        { model | position = newPosition }

    Fire firing ->
      let
        newPowerLevel =
          if firing then
            max 1 (model.powerLevel - 1)
          else
            model.powerLevel

        missles =
          if firing then
            { x = toFloat model.position
            , y = (shipTopPosition (toFloat model.gameHeight)) + 30
            } :: model.firedMissles
          else
            model.firedMissles
      in
        { model |
          isFiring = firing,
          powerLevel = newPowerLevel,
          firedMissles = missles
        }

    Tick ->
      let
        newPowerLevel =
          min 10 (model.powerLevel + 1)
      in
        { model | powerLevel = newPowerLevel }

    PropelMissle ->
      let
        dropMissle missle =
          if missle.y >= gameTop then Nothing else Just missle
        gameTop =
          (toFloat model.gameHeight) + (shipTopPosition (toFloat model.gameHeight))
        cleanMissleList =
          List.filterMap dropMissle model.firedMissles
        updatedMissles =
          List.map propelMissle cleanMissleList
        propelMissle missle =
          { missle | y = missle.y + 10 }
      in
        { model | firedMissles = updatedMissles }

    DimensionsChanged (w, h) ->
      { model | gameWidth = w, gameHeight = h }

-- VIEW

view : (Int, Int) -> Model -> Element
view (w, h) model =
  let
    (w', h') = (toFloat w, toFloat h)
    gameBoardObjects =
      [ drawGame w' h'
      , drawShip h' model
      , toForm (show model)
      ]
    missleObjects =
      drawActiveMissles model.firedMissles
    gameWithMissles =
      List.append gameBoardObjects missleObjects
  in
    collage w h gameWithMissles

drawGame : Float -> Float -> Form
drawGame w h =
  rect w h
    |> filled gray

drawActiveMissles : List Missle -> List Form
drawActiveMissles missles =
  List.map drawMissle missles

drawMissle : Missle -> Form
drawMissle missle =
  rect 10 10
    |> filled red
    |> move (missle.x, missle.y)

drawShip : Float -> Model -> Form
drawShip gameHeight ship =
  ngon 3 30
    |> filled blue
    |> rotate (degrees 90)
    |> move ((toFloat ship.position), (shipTopPosition gameHeight))
    |> alpha ((toFloat ship.powerLevel) / 10)
    |> Debug.trace 

shipTopPosition : Float -> Float
shipTopPosition gameHeight =
  (50 - gameHeight / 2)
-- SIGNALS

direction : Signal Action
direction =
  let
    x = Signal.map .x Keyboard.arrows
    delta = Time.fps 120
    toAction n =
      case n of
        -1 -> Left
        1 -> Right
        _ -> NoOp
    action = Signal.map toAction x
  in
    Signal.sampleOn delta action

fire : Signal Action
fire =
  Signal.map Fire Keyboard.space

healthRestoreTimer : Signal Action
healthRestoreTimer =
  Signal.map (always Tick) (Time.every Time.second)

propelMissle : Signal Action
propelMissle =
  Signal.map (always PropelMissle) (Time.fps 30)

dimensions : Signal Action
dimensions =
  Signal.map DimensionsChanged Window.dimensions

input : Signal Action
input =
  Signal.mergeMany [dimensions, direction, fire, healthRestoreTimer, propelMissle]

state : Signal Model
state =
  Signal.foldp update initialShip input

main : Signal Element
main =
  Signal.map2 view Window.dimensions state
