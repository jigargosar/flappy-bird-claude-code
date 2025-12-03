module Sprites exposing (viewBird)

import Svg exposing (..)
import Svg.Attributes exposing (..)


viewBird : { bgColor : String, x : Float, y : Float, velocity : Float, size : Float } -> Svg msg
viewBird config =
    let
        rotation =
            clamp -30 90 (config.velocity * 5)
    in
    g
        [ transform
            ("translate(" ++ String.fromFloat (config.x + config.size / 2) ++ "," ++ String.fromFloat (config.y + config.size / 2) ++ ") " ++
             "rotate(" ++ String.fromFloat rotation ++ ")")
        ]
        [ -- Body (ellipse)
          ellipse
            [ cx "0"
            , cy "0"
            , rx "15"
            , ry "12"
            , fill config.bgColor
            ]
            []
        , -- Beak (triangle/polygon)
          polygon
            [ points "12,0 22,0 17,-3"
            , fill config.bgColor
            , opacity "0.8"
            ]
            []
        , -- Eye (larger circle)
          circle
            [ cx "5"
            , cy "-3"
            , r "3"
            , fill "white"
            ]
            []
        , -- Pupil
          circle
            [ cx "6"
            , cy "-3"
            , r "1.5"
            , fill "black"
            ]
            []
        , -- Wing (ellipse)
          ellipse
            [ cx "-3"
            , cy "5"
            , rx "8"
            , ry "5"
            , fill config.bgColor
            , opacity "0.7"
            ]
            []
        , -- Tail feathers (small triangles)
          polygon
            [ points "-15,0 -20,-3 -18,0"
            , fill config.bgColor
            , opacity "0.8"
            ]
            []
        , polygon
            [ points "-15,2 -20,4 -18,3"
            , fill config.bgColor
            , opacity "0.8"
            ]
            []
        , polygon
            [ points "-15,-2 -20,-5 -18,-3"
            , fill config.bgColor
            , opacity "0.8"
            ]
            []
        , -- Legs (thin lines)
          line
            [ x1 "-2"
            , y1 "10"
            , x2 "-2"
            , y2 "16"
            , stroke config.bgColor
            , strokeWidth "1.5"
            ]
            []
        , line
            [ x1 "2"
            , y1 "10"
            , x2 "2"
            , y2 "16"
            , stroke config.bgColor
            , strokeWidth "1.5"
            ]
            []
        , -- Feet (tiny lines)
          line
            [ x1 "-2"
            , y1 "16"
            , x2 "-5"
            , y2 "16"
            , stroke config.bgColor
            , strokeWidth "1.5"
            ]
            []
        , line
            [ x1 "2"
            , y1 "16"
            , x2 "5"
            , y2 "16"
            , stroke config.bgColor
            , strokeWidth "1.5"
            ]
            []
        ]
