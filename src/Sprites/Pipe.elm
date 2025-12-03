module Sprites.Pipe exposing (viewPipe)

import Svg exposing (..)
import Svg.Attributes exposing (..)


viewPipe : { x : Float, gapY : Float, bgColor : String, pipeWidth : Float, pipeGap : Float, gameHeight : Float } -> Svg msg
viewPipe config =
    let
        capHeight =
            25

        capWidth =
            config.pipeWidth + 8

        capOffset =
            (capWidth - config.pipeWidth) / 2

        topPipeHeight =
            config.gapY

        bottomPipeY =
            config.gapY + config.pipeGap

        bottomPipeHeight =
            config.gameHeight - config.gapY - config.pipeGap
    in
    g []
        [ -- Top pipe body
          rect
            [ x (String.fromFloat config.x)
            , y "0"
            , width (String.fromFloat config.pipeWidth)
            , height (String.fromFloat (topPipeHeight - capHeight))
            , fill config.bgColor
            ]
            []
        , -- Top pipe highlight (left side)
          rect
            [ x (String.fromFloat config.x)
            , y "0"
            , width "4"
            , height (String.fromFloat (topPipeHeight - capHeight))
            , fill "rgba(255, 255, 255, 0.15)"
            ]
            []
        , -- Top pipe shadow (right side)
          rect
            [ x (String.fromFloat (config.x + config.pipeWidth - 4))
            , y "0"
            , width "4"
            , height (String.fromFloat (topPipeHeight - capHeight))
            , fill "rgba(0, 0, 0, 0.2)"
            ]
            []
        , -- Top pipe cap
          rect
            [ x (String.fromFloat (config.x - capOffset))
            , y (String.fromFloat (topPipeHeight - capHeight))
            , width (String.fromFloat capWidth)
            , height (String.fromFloat capHeight)
            , fill config.bgColor
            ]
            []
        , -- Top pipe cap highlight
          rect
            [ x (String.fromFloat (config.x - capOffset))
            , y (String.fromFloat (topPipeHeight - capHeight))
            , width "4"
            , height (String.fromFloat capHeight)
            , fill "rgba(255, 255, 255, 0.2)"
            ]
            []
        , -- Top pipe cap shadow
          rect
            [ x (String.fromFloat (config.x + config.pipeWidth + capOffset - 4))
            , y (String.fromFloat (topPipeHeight - capHeight))
            , width "4"
            , height (String.fromFloat capHeight)
            , fill "rgba(0, 0, 0, 0.25)"
            ]
            []
        , -- Bottom pipe body
          rect
            [ x (String.fromFloat config.x)
            , y (String.fromFloat (bottomPipeY + capHeight))
            , width (String.fromFloat config.pipeWidth)
            , height (String.fromFloat (bottomPipeHeight - capHeight))
            , fill config.bgColor
            ]
            []
        , -- Bottom pipe highlight (left side)
          rect
            [ x (String.fromFloat config.x)
            , y (String.fromFloat (bottomPipeY + capHeight))
            , width "4"
            , height (String.fromFloat (bottomPipeHeight - capHeight))
            , fill "rgba(255, 255, 255, 0.15)"
            ]
            []
        , -- Bottom pipe shadow (right side)
          rect
            [ x (String.fromFloat (config.x + config.pipeWidth - 4))
            , y (String.fromFloat (bottomPipeY + capHeight))
            , width "4"
            , height (String.fromFloat (bottomPipeHeight - capHeight))
            , fill "rgba(0, 0, 0, 0.2)"
            ]
            []
        , -- Bottom pipe cap
          rect
            [ x (String.fromFloat (config.x - capOffset))
            , y (String.fromFloat bottomPipeY)
            , width (String.fromFloat capWidth)
            , height (String.fromFloat capHeight)
            , fill config.bgColor
            ]
            []
        , -- Bottom pipe cap highlight
          rect
            [ x (String.fromFloat (config.x - capOffset))
            , y (String.fromFloat bottomPipeY)
            , width "4"
            , height (String.fromFloat capHeight)
            , fill "rgba(255, 255, 255, 0.2)"
            ]
            []
        , -- Bottom pipe cap shadow
          rect
            [ x (String.fromFloat (config.x + config.pipeWidth + capOffset - 4))
            , y (String.fromFloat bottomPipeY)
            , width "4"
            , height (String.fromFloat capHeight)
            , fill "rgba(0, 0, 0, 0.25)"
            ]
            []
        ]
