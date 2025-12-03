module Sprites.Bird exposing (viewBird)

import Svg exposing (..)
import Svg.Attributes exposing (..)


viewBird : { bgColor : String } -> Svg msg
viewBird config =
    g []
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
            [ points "12,-1 20,0 12,1"
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
