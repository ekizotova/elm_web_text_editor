port module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (string)



-- PORTS


port applyFormat : String -> Cmd msg


port receiveUpdatedText : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { content : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { content = "" }, Cmd.none )



-- UPDATE


type Msg
    = FormatBold
    | FormatItalic
    | GotUpdatedText String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormatBold ->
            ( model, applyFormat "bold" )

        FormatItalic ->
            ( model, applyFormat "italic" )

        GotUpdatedText newText ->
            ( { model | content = newText }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Elm Text Editor" ]
        , div []
            [ button [ onClick FormatBold ] [ text "Bold" ]
            , button [ onClick FormatItalic ] [ text "Italic" ]
            ]
        , div [ id "editor", contenteditable True, style "margin-top" "1em" ]
            [ text "" ]
        , h3 [] [ text "Aktuální HTML výstup:" ]
        , pre [] [ text model.content ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveUpdatedText GotUpdatedText



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
