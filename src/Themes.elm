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
    , { name = "DARK FOREST"
      , bgSky = "#0A1824"
      , bgGround = "#132F13"
      , bgPipes = "#2A4930"
      , bgBird = "#ff8c42"
      , fgScore = "#a8d5ba"
      , fgReadyTitle = "#d4e4d8"
      , fgReadySubtitle = "#d4e4d8"
      , fgGameOverTitle = "#86470C"
      , fgGameOverSubtitle = "#d4e4d8"
      }
    , { name = "SPACE ODYSSEY"
      , bgSky = "#000000"
      , bgGround = "#1a1a1a"
      , bgPipes = "#2a2a2a"
      , bgBird = "#FF1DD3"
      , fgScore = "#7EFCFF"
      , fgReadyTitle = "#f0f0f0"
      , fgReadySubtitle = "#f0f0f0"
      , fgGameOverTitle = "#FF0000"
      , fgGameOverSubtitle = "#f0f0f0"
      }
    , { name = "GOTHIC NOIR"
      , bgSky = "#0a0a0a"
      , bgGround = "#1E1B1E"
      , bgPipes = "#3a3a3a"
      , bgBird = "#b33939"
      , fgScore = "#c0c0c0"
      , fgReadyTitle = "#d0d0d0"
      , fgReadySubtitle = "#d0d0d0"
      , fgGameOverTitle = "#8b0000"
      , fgGameOverSubtitle = "#d0d0d0"
      }
    , { name = "NEON NIGHT"
      , bgSky = "#1D1D1D"
      , bgGround = "#2d2d2d"
      , bgPipes = "#3d3d3d"
      , bgBird = "#FF00EA"
      , fgScore = "#00C7FF"
      , fgReadyTitle = "#e8e8e8"
      , fgReadySubtitle = "#e8e8e8"
      , fgGameOverTitle = "#FF00EA"
      , fgGameOverSubtitle = "#e8e8e8"
      }
    , { name = "POST-APOCALYPTIC"
      , bgSky = "#1E1E1E"
      , bgGround = "#2e2e2e"
      , bgPipes = "#4a4a4a"
      , bgBird = "#F16835"
      , fgScore = "#b8a896"
      , fgReadyTitle = "#d4d4d4"
      , fgReadySubtitle = "#d4d4d4"
      , fgGameOverTitle = "#F16835"
      , fgGameOverSubtitle = "#d4d4d4"
      }
    , { name = "INDUSTRIAL GRITTY"
      , bgSky = "#020004"
      , bgGround = "#172D55"
      , bgPipes = "#4A616F"
      , bgBird = "#E77023"
      , fgScore = "#a8c5d9"
      , fgReadyTitle = "#e0e0e0"
      , fgReadySubtitle = "#e0e0e0"
      , fgGameOverTitle = "#E77023"
      , fgGameOverSubtitle = "#e0e0e0"
      }
    , { name = "DEEP JEWEL TONES"
      , bgSky = "#1A1A1A"
      , bgGround = "#2a2a2a"
      , bgPipes = "#004D61"
      , bgBird = "#d4af37"
      , fgScore = "#5fb3c7"
      , fgReadyTitle = "#e5e5e5"
      , fgReadySubtitle = "#e5e5e5"
      , fgGameOverTitle = "#822659"
      , fgGameOverSubtitle = "#e5e5e5"
      }
    , { name = "DARK FANTASY"
      , bgSky = "#1B1C1E"
      , bgGround = "#2D2343"
      , bgPipes = "#4a3a5a"
      , bgBird = "#d4af37"
      , fgScore = "#b8a8d0"
      , fgReadyTitle = "#e0e0e0"
      , fgReadySubtitle = "#e0e0e0"
      , fgGameOverTitle = "#a84854"
      , fgGameOverSubtitle = "#e0e0e0"
      }
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
    , { name = "TOXIC GARDEN"
      , bgSky = "#0f1b0e"
      , bgGround = "#1a2f1a"
      , bgPipes = "#2d5016"
      , bgBird = "#c77dff"
      , fgScore = "#c4ff61"
      , fgReadyTitle = "#f0f0f0"
      , fgReadySubtitle = "#f0f0f0"
      , fgGameOverTitle = "#e0aaff"
      , fgGameOverSubtitle = "#f0f0f0"
      }
    , { name = "DEEP SPACE"
      , bgSky = "#0a0a12"
      , bgGround = "#1a1a2e"
      , bgPipes = "#2e3856"
      , bgBird = "#fbbf24"
      , fgScore = "#a78bfa"
      , fgReadyTitle = "#e5e7eb"
      , fgReadySubtitle = "#e5e7eb"
      , fgGameOverTitle = "#60a5fa"
      , fgGameOverSubtitle = "#e5e7eb"
      }
    , { name = "MOLTEN CORE"
      , bgSky = "#1c1c1e"
      , bgGround = "#2d2d30"
      , bgPipes = "#424242"
      , bgBird = "#ff6b35"
      , fgScore = "#ffd60a"
      , fgReadyTitle = "#f5f5f5"
      , fgReadySubtitle = "#f5f5f5"
      , fgGameOverTitle = "#ff4365"
      , fgGameOverSubtitle = "#f5f5f5"
      }
    ]


getTheme : Int -> Theme
getTheme index =
    themes
        |> List.drop (modBy (List.length themes) index)
        |> List.head
        |> Maybe.withDefault defaultTheme
