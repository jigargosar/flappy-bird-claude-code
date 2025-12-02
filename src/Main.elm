module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (Html)
import Json.Decode as Decode
import Svg exposing (..)
import Svg.Attributes exposing (..)
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
    30


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
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Frame Time.Posix
    | Jump
    | Restart


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Frame _ ->
            case model.gameState of
                Playing ->
                    model
                        |> updateBird
                        |> updatePipes
                        |> spawnPipes
                        |> updateScore
                        |> checkCollisions
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
                    init ()

                _ ->
                    ( model, Cmd.none )


updateBird : Model -> Model
updateBird model =
    let
        bird =
            model.bird

        newVelocity =
            bird.velocity + gravity

        newY =
            bird.y + newVelocity
    in
    { model | bird = { bird | y = newY, velocity = newVelocity } }


updatePipes : Model -> Model
updatePipes model =
    let
        updatedPipes =
            model.pipes
                |> List.map (\pipe -> { pipe | x = pipe.x - pipeSpeed })
                |> List.filter (\pipe -> pipe.x > -pipeWidth)
    in
    { model | pipes = updatedPipes }


spawnPipes : Model -> Model
spawnPipes model =
    if modBy pipeSpawnInterval model.frameCount == 0 then
        let
            gapY =
                200 + toFloat (modBy 200 (model.frameCount // 10)) * 1.5

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
        [ Browser.Events.onAnimationFrame Frame
        , Browser.Events.onKeyDown (Decode.map (\_ -> Jump) (Decode.field "key" (Decode.string |> Decode.andThen spacebarDecoder)))
        , Browser.Events.onClick (Decode.succeed Jump)
        , Browser.Events.onKeyDown (Decode.map (\_ -> Restart) (Decode.field "key" (Decode.string |> Decode.andThen restartDecoder)))
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



-- VIEW


view : Model -> Html Msg
view model =
    svg
        [ width (String.fromFloat gameWidth)
        , height (String.fromFloat gameHeight)
        , viewBox ("0 0 " ++ String.fromFloat gameWidth ++ " " ++ String.fromFloat gameHeight)
        , Svg.Attributes.style "display: block; background-color: #1e1b4b;"
        ]
        [ viewBackground
        , viewPipes model.pipes
        , viewBird model.bird
        , viewScore model.score
        , viewGameState model.gameState
        ]


viewBackground : Svg Msg
viewBackground =
    rect
        [ x "0"
        , y (String.fromFloat (gameHeight - 100))
        , width (String.fromFloat gameWidth)
        , height "100"
        , fill "#4338ca"
        ]
        []


viewBird : Bird -> Svg Msg
viewBird bird =
    circle
        [ cx (String.fromFloat (birdX + birdSize / 2))
        , cy (String.fromFloat (bird.y + birdSize / 2))
        , r (String.fromFloat (birdSize / 2))
        , fill "#f472b6"
        ]
        []


viewPipes : List Pipe -> Svg Msg
viewPipes pipes =
    g [] (List.concatMap viewPipe pipes)


viewPipe : Pipe -> List (Svg Msg)
viewPipe pipe =
    [ rect
        [ x (String.fromFloat pipe.x)
        , y "0"
        , width (String.fromFloat pipeWidth)
        , height (String.fromFloat pipe.gapY)
        , fill "#60a5fa"
        ]
        []
    , rect
        [ x (String.fromFloat pipe.x)
        , y (String.fromFloat (pipe.gapY + pipeGap))
        , width (String.fromFloat pipeWidth)
        , height (String.fromFloat (gameHeight - pipe.gapY - pipeGap))
        , fill "#60a5fa"
        ]
        []
    ]


viewScore : Int -> Svg Msg
viewScore score =
    text_
        [ x (String.fromFloat (gameWidth / 2))
        , y "50"
        , fontSize "48"
        , fontWeight "bold"
        , fill "#22d3ee"
        , textAnchor "middle"
        ]
        [ text (String.fromInt score) ]


viewGameState : GameState -> Svg Msg
viewGameState gameState =
    case gameState of
        Ready ->
            g []
                [ text_
                    [ x (String.fromFloat (gameWidth / 2))
                    , y (String.fromFloat (gameHeight / 2))
                    , fontSize "32"
                    , fontWeight "bold"
                    , fill "#ffffff"
                    , textAnchor "middle"
                    ]
                    [ text "Click or Press Space" ]
                , text_
                    [ x (String.fromFloat (gameWidth / 2))
                    , y (String.fromFloat (gameHeight / 2 + 40))
                    , fontSize "24"
                    , fill "#ffffff"
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
                    , fill "#f472b6"
                    , textAnchor "middle"
                    ]
                    [ text "Game Over" ]
                , text_
                    [ x (String.fromFloat (gameWidth / 2))
                    , y (String.fromFloat (gameHeight / 2 + 20))
                    , fontSize "24"
                    , fill "#ffffff"
                    , textAnchor "middle"
                    ]
                    [ text "Press Space to Restart" ]
                ]
