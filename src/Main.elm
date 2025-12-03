module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (onInput)
import Json.Decode as Decode
import Sprites.Bird
import Sprites.Pipe
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events
import Themes exposing (Theme)
import Time



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { bird : Bird
    , pipes : List Pipe
    , score : Int
    , gameState : GameState
    , frameCount : Int
    , currentTheme : Int
    }


type alias Bird =
    { y : Float
    , velocity : Float
    }


type alias Pipe =
    { x : Float
    , gapY : Float
    , scored : Bool
    }


type GameState
    = Ready
    | Playing
    | GameOver



-- CONSTANTS


gameWidth : Float
gameWidth =
    400


gameHeight : Float
gameHeight =
    600


birdX : Float
birdX =
    100


birdSize : Float
birdSize =
    40


gravity : Float
gravity =
    0.6


jumpVelocity : Float
jumpVelocity =
    -8


pipeWidth : Float
pipeWidth =
    60


pipeGap : Float
pipeGap =
    150


pipeSpeed : Float
pipeSpeed =
    2


pipeSpawnInterval : Int
pipeSpawnInterval =
    120



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { bird = { y = gameHeight / 2, velocity = 0 }
      , pipes = []
      , score = 0
      , gameState = Ready
      , frameCount = 0
      , currentTheme = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Frame Float
    | Jump
    | Restart
    | CycleTheme
    | PrevTheme
    | SetTheme String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Frame rawDelta ->
            let
                -- Clamp delta to max 50ms to prevent huge jumps when tab returns from background
                delta =
                    Basics.min rawDelta 50.0

                -- Convert to seconds for physics calculations
                dt =
                    delta / 1000.0
            in
            case model.gameState of
                Playing ->
                    model
                        |> updateBird dt
                        |> updatePipes dt
                        |> spawnPipes
                        |> updateScore
                        -- |> checkCollisions
                        |> (\m -> ( { m | frameCount = m.frameCount + 1 }, Cmd.none ))

                _ ->
                    ( model, Cmd.none )

        Jump ->
            case model.gameState of
                Ready ->
                    ( { model
                        | gameState = Playing
                        , bird = { y = model.bird.y, velocity = jumpVelocity }
                      }
                    , Cmd.none
                    )

                Playing ->
                    ( { model | bird = { y = model.bird.y, velocity = jumpVelocity } }
                    , Cmd.none
                    )

                GameOver ->
                    ( model, Cmd.none )

        Restart ->
            case model.gameState of
                GameOver ->
                    let
                        ( newModel, cmd ) =
                            init ()
                    in
                    ( { newModel | currentTheme = model.currentTheme }, cmd )

                _ ->
                    ( model, Cmd.none )

        CycleTheme ->
            ( { model | currentTheme = model.currentTheme + 1 }, Cmd.none )

        PrevTheme ->
            ( { model | currentTheme = model.currentTheme - 1 }, Cmd.none )

        SetTheme indexStr ->
            case String.toInt indexStr of
                Just index ->
                    ( { model | currentTheme = index }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


updateBird : Float -> Model -> Model
updateBird dt model =
    let
        bird =
            model.bird

        -- Convert gravity from per-frame to per-second (gravity * 60fps = 36 units/sec)
        gravityPerSecond =
            gravity * 60

        newVelocity =
            bird.velocity + (gravityPerSecond * dt)

        calculatedY =
            bird.y + (newVelocity * dt * 60)

        maxY =
            gameHeight - birdSize

        newY =
            clamp 0 maxY calculatedY
    in
    { model | bird = { bird | y = newY, velocity = newVelocity } }


updatePipes : Float -> Model -> Model
updatePipes dt model =
    let
        -- Convert pipeSpeed from per-frame to per-second (pipeSpeed * 60fps = 120 units/sec)
        pipeSpeedPerSecond =
            pipeSpeed * 60

        updatedPipes =
            model.pipes
                |> List.map (\pipe -> { pipe | x = pipe.x - (pipeSpeedPerSecond * dt) })
                |> List.filter (\pipe -> pipe.x > -pipeWidth)
    in
    { model | pipes = updatedPipes }


spawnPipes : Model -> Model
spawnPipes model =
    if modBy pipeSpawnInterval model.frameCount == 0 then
        let
            variation =
                toFloat (modBy 250 (model.frameCount // 10))

            gapY =
                100 + variation

            newPipe =
                { x = gameWidth, gapY = gapY, scored = False }
        in
        { model | pipes = model.pipes ++ [ newPipe ] }

    else
        model


updateScore : Model -> Model
updateScore model =
    let
        newlyScored =
            List.filter (\pipe -> not pipe.scored && pipe.x + pipeWidth < birdX) model.pipes
                |> List.length

        updatedPipes =
            List.map
                (\pipe ->
                    if not pipe.scored && pipe.x + pipeWidth < birdX then
                        { pipe | scored = True }

                    else
                        pipe
                )
                model.pipes
    in
    { model | pipes = updatedPipes, score = model.score + newlyScored }


checkCollisions : Model -> Model
checkCollisions model =
    let
        bird =
            model.bird

        hitGround =
            bird.y + birdSize > gameHeight

        hitCeiling =
            bird.y < 0

        hitPipe =
            List.any (checkPipeCollision bird) model.pipes
    in
    if hitGround || hitCeiling || hitPipe then
        { model | gameState = GameOver }

    else
        model


checkPipeCollision : Bird -> Pipe -> Bool
checkPipeCollision bird pipe =
    let
        birdLeft =
            birdX

        birdRight =
            birdX + birdSize

        birdTop =
            bird.y

        birdBottom =
            bird.y + birdSize

        pipeLeft =
            pipe.x

        pipeRight =
            pipe.x + pipeWidth

        topPipeBottom =
            pipe.gapY

        bottomPipeTop =
            pipe.gapY + pipeGap

        horizontalOverlap =
            birdRight > pipeLeft && birdLeft < pipeRight

        hitTopPipe =
            birdTop < topPipeBottom

        hitBottomPipe =
            birdBottom > bottomPipeTop
    in
    horizontalOverlap && (hitTopPipe || hitBottomPipe)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Browser.Events.onAnimationFrameDelta Frame
        , Browser.Events.onKeyDown (Decode.map (\_ -> Jump) (Decode.field "key" (Decode.string |> Decode.andThen spacebarDecoder)))
        , Browser.Events.onKeyDown (Decode.map (\_ -> Restart) (Decode.field "key" (Decode.string |> Decode.andThen restartDecoder)))
        , Browser.Events.onKeyDown keyDecoder
        ]


spacebarDecoder : String -> Decode.Decoder ()
spacebarDecoder key =
    if key == " " then
        Decode.succeed ()

    else
        Decode.fail "Not spacebar"


restartDecoder : String -> Decode.Decoder ()
restartDecoder key =
    if key == " " then
        Decode.succeed ()

    else
        Decode.fail "Not spacebar"


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.field "key" Decode.string
        |> Decode.andThen
            (\key ->
                case key of
                    "ArrowLeft" ->
                        Decode.succeed PrevTheme

                    "ArrowRight" ->
                        Decode.succeed CycleTheme

                    "t" ->
                        Decode.succeed CycleTheme

                    "T" ->
                        Decode.succeed CycleTheme

                    _ ->
                        Decode.fail "Not a theme key"
            )



-- VIEW


view : Model -> Html Msg
view model =
    let
        theme =
            Themes.getTheme model.currentTheme
    in
    Html.div
        [ Html.Attributes.class "relative inline-block select-none"
        ]
        [ svg
            [ width (String.fromFloat gameWidth)
            , height (String.fromFloat gameHeight)
            , viewBox ("0 0 " ++ String.fromFloat gameWidth ++ " " ++ String.fromFloat gameHeight)
            , Svg.Attributes.class "block"
            , Svg.Attributes.style ("background-color: " ++ theme.bgSky ++ ";")
            , Svg.Events.on "pointerdown" (Decode.succeed Jump)
            ]
            [ viewBackground theme
            , viewPipes theme model.pipes
            , viewBird theme model.bird
            , viewScore theme model.score
            , viewGameState theme model.gameState
            ]
        , viewThemeControls model.currentTheme
        ]


viewBackground : Theme -> Svg Msg
viewBackground theme =
    rect
        [ x "0"
        , y (String.fromFloat (gameHeight - 100))
        , width (String.fromFloat gameWidth)
        , height "100"
        , fill theme.bgGround
        ]
        []


viewBird : Theme -> Bird -> Svg Msg
viewBird theme bird =
    let
        defaultBirdSize =
            30

        scale =
            birdSize / defaultBirdSize

        rotation =
            clamp -30 90 (bird.velocity * 5)

        centerX =
            birdX + birdSize / 2

        centerY =
            bird.y + birdSize / 2
    in
    g
        [ transform
            ("translate("
                ++ String.fromFloat centerX
                ++ ","
                ++ String.fromFloat centerY
                ++ ") "
                ++ "rotate("
                ++ String.fromFloat rotation
                ++ ") "
                ++ "scale("
                ++ String.fromFloat scale
                ++ ")"
            )
        ]
        [ Sprites.Bird.viewBird
            { bgColor = theme.bgBird
            }
        ]


viewPipes : Theme -> List Pipe -> Svg Msg
viewPipes theme pipes =
    g []
        (List.map
            (\pipe ->
                Sprites.Pipe.viewPipe
                    { x = pipe.x
                    , gapY = pipe.gapY
                    , bgColor = theme.bgPipes
                    , pipeWidth = pipeWidth
                    , pipeGap = pipeGap
                    , gameHeight = gameHeight
                    }
            )
            pipes
        )


viewScore : Theme -> Int -> Svg Msg
viewScore theme score =
    text_
        [ x (String.fromFloat (gameWidth / 2))
        , y "50"
        , fontSize "48"
        , fontWeight "bold"
        , fill theme.fgScore
        , textAnchor "middle"
        ]
        [ text (String.fromInt score) ]


viewGameState : Theme -> GameState -> Svg Msg
viewGameState theme gameState =
    case gameState of
        Ready ->
            g []
                [ text_
                    [ x (String.fromFloat (gameWidth / 2))
                    , y (String.fromFloat (gameHeight / 2))
                    , fontSize "32"
                    , fontWeight "bold"
                    , fill theme.fgReadyTitle
                    , textAnchor "middle"
                    ]
                    [ text "Click or Press Space" ]
                , text_
                    [ x (String.fromFloat (gameWidth / 2))
                    , y (String.fromFloat (gameHeight / 2 + 40))
                    , fontSize "24"
                    , fill theme.fgReadySubtitle
                    , textAnchor "middle"
                    ]
                    [ text "to Start" ]
                ]

        Playing ->
            g [] []

        GameOver ->
            g []
                [ text_
                    [ x (String.fromFloat (gameWidth / 2))
                    , y (String.fromFloat (gameHeight / 2 - 40))
                    , fontSize "48"
                    , fontWeight "bold"
                    , fill theme.fgGameOverTitle
                    , textAnchor "middle"
                    ]
                    [ text "Game Over" ]
                , text_
                    [ x (String.fromFloat (gameWidth / 2))
                    , y (String.fromFloat (gameHeight / 2 + 20))
                    , fontSize "24"
                    , fill theme.fgGameOverSubtitle
                    , textAnchor "middle"
                    ]
                    [ text "Press Space to Restart" ]
                ]


viewThemeControls : Int -> Html Msg
viewThemeControls currentIndex =
    Html.div
        [ Html.Attributes.class "absolute bottom-2.5 left-1/2 -translate-x-1/2 flex items-center gap-2 px-3 py-2 bg-black/70 rounded-md"
        , Html.Events.stopPropagationOn "click" (Decode.succeed ( NoOp, True ))
        , Html.Events.stopPropagationOn "mousedown" (Decode.succeed ( NoOp, True ))
        , Html.Events.stopPropagationOn "mouseup" (Decode.succeed ( NoOp, True ))
        , Html.Events.stopPropagationOn "keydown" (Decode.succeed ( NoOp, True ))
        , Html.Events.stopPropagationOn "keyup" (Decode.succeed ( NoOp, True ))
        , Html.Events.stopPropagationOn "keypress" (Decode.succeed ( NoOp, True ))
        ]
        [ Html.span
            [ Html.Attributes.class "text-gray-400 text-sm" ]
            [ Html.text "← " ]
        , Html.select
            [ Html.Attributes.class "px-2 py-1 bg-gray-800 text-white border border-gray-600 rounded cursor-pointer text-xs"
            , onInput SetTheme
            , Html.Attributes.value (String.fromInt (modBy (List.length Themes.themes) currentIndex))
            ]
            (List.indexedMap
                (\index theme ->
                    Html.option
                        [ Html.Attributes.value (String.fromInt index)
                        , Html.Attributes.class "bg-gray-800 text-white"
                        ]
                        [ Html.text theme.name ]
                )
                Themes.themes
            )
        , Html.span
            [ Html.Attributes.class "text-gray-400 text-sm" ]
            [ Html.text " →" ]
        ]
