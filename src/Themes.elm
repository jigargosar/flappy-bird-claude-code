module Themes exposing (Theme, defaultTheme, themes, getTheme)


type alias Theme =
    { name : String
    , bgSky : String
    , bgGround : String
    , bgPipes : String
    , bgBird : String
    , fgScore : String
    , fgReadyTitle : String
    , fgReadySubtitle : String
    , fgGameOverTitle : String
    , fgGameOverSubtitle : String
    }


defaultTheme : Theme
defaultTheme =
    { name = "CYBERPUNK DREAMS"
    , bgSky = "#0a0a0a"
    , bgGround = "#1a1a1a"
    , bgPipes = "#1E90FF"
    , bgBird = "#FF1493"
    , fgScore = "#00FF7F"
    , fgReadyTitle = "#e0e0e0"
    , fgReadySubtitle = "#e0e0e0"
    , fgGameOverTitle = "#FF1493"
    , fgGameOverSubtitle = "#e0e0e0"
    }


themes : List Theme
themes =
    [ defaultTheme
    , { name = "MIDNIGHT EMBERS"
      , bgSky = "#0d1b2a"
      , bgGround = "#1b263b"
      , bgPipes = "#415a77"
      , bgBird = "#ff9d5c"
      , fgScore = "#ffd89b"
      , fgReadyTitle = "#e0e1dd"
      , fgReadySubtitle = "#e0e1dd"
      , fgGameOverTitle = "#ff6b35"
      , fgGameOverSubtitle = "#e0e1dd"
      }
    ]


getTheme : Int -> Theme
getTheme index =
    themes
        |> List.drop (modBy (List.length themes) index)
        |> List.head
        |> Maybe.withDefault defaultTheme
