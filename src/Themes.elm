module Themes exposing (Theme, defaultTheme, themes, getTheme)


type alias Theme =
    { name : String
    , sky : String
    , ground : String
    , pipes : String
    , bird : String
    , score : String
    , titleText : String
    , instructionText : String
    }


defaultTheme : Theme
defaultTheme =
    { name = "CYBERPUNK DREAMS"
    , sky = "#0a0a0a"
    , ground = "#1a1a1a"
    , pipes = "#1E90FF"
    , bird = "#FF1493"
    , score = "#00FF7F"
    , titleText = "#FF1493"
    , instructionText = "#e0e0e0"
    }


themes : List Theme
themes =
    [ defaultTheme
    , { name = "MIDNIGHT EMBERS"
      , sky = "#0d1b2a"
      , ground = "#1b263b"
      , pipes = "#415a77"
      , bird = "#ff9d5c"
      , score = "#ffd89b"
      , titleText = "#ff6b35"
      , instructionText = "#e0e1dd"
      }
    ]


getTheme : Int -> Theme
getTheme index =
    themes
        |> List.drop (modBy (List.length themes) index)
        |> List.head
        |> Maybe.withDefault defaultTheme
