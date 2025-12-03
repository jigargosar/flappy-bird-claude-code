module Sprites.Bird exposing (viewBird)

import Svg exposing (..)
import Svg.Attributes exposing (..)


viewBird : { bgColor : String, frameCount : Int } -> Svg msg
viewBird config =
    let
        -- Calculate wing rotation angle using sine wave for smooth flapping
        -- Flap cycle: 25 frames per full cycle (slower, smoother flapping)
        flapCycle =
            25

        -- Convert frame to angle (-45 to 45 degrees for prominent but not excessive flapping)
        wingAngle =
            sin (toFloat (modBy flapCycle config.frameCount) * (2 * pi / toFloat flapCycle)) * 45
    in
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
            [ points "12,-3 25,0 12,3"
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
        , -- Wing (ellipse like body, with rotation animation)
          ellipse
            [ cx "-10"
            , cy "7"
            , rx "10"
            , ry "6"
            , fill config.bgColor
            , stroke "rgba(0,0,0,0.4)"
            , strokeWidth "1.5"
            , opacity "0.9"
            , transform ("rotate(" ++ String.fromFloat wingAngle ++ " 0 7)")
            ]
            []
        , -- Tail feathers (enlarged triangles)
          polygon
            [ points "-15,0 -25,-6 -20,0"
            , fill config.bgColor
            , opacity "0.8"
            ]
            []
        , polygon
            [ points "-15,4 -25,8 -20,5"
            , fill config.bgColor
            , opacity "0.8"
            ]
            []
        , polygon
            [ points "-15,-4 -25,-10 -20,-5"
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
