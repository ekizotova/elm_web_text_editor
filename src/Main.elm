port module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (string)



-- PORTS


port applyFormat : String -> Cmd msg


port receiveUpdatedText : (String -> msg) -> Sub msg


port exportContent : String -> Cmd msg



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
    | ClearFormatting
    | AlignLeft
    | AlignCenter
    | AlignRight
    | AddTab
    | ReplaceDashes
    | ClearOutput
    | ExportAs String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormatBold ->
            ( model, applyFormat "bold" )

        FormatItalic ->
            ( model, applyFormat "italic" )

        ClearFormatting ->
            ( model, applyFormat "clear" )

        AlignLeft ->
            ( model, applyFormat "align-left" )

        AlignCenter ->
            ( model, applyFormat "align-center" )

        AlignRight ->
            ( model, applyFormat "align-right" )

        AddTab ->
            ( model, applyFormat "tab" )

        ReplaceDashes ->
            ( model, applyFormat "em-dash" )

        GotUpdatedText newText ->
            ( { model | content = newText }, Cmd.none )

        ClearOutput ->
            ( { model | content = "" }, Cmd.none )

        ExportAs format ->
            ( model, exportContent (format ++ "::" ++ model.content) )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Elm Text Editor" ]
        , div []
            [ button [ onClick FormatBold ] [ text "Bold" ]
            , button [ onClick FormatItalic ] [ text "Italic" ]
            , button [ onClick ClearFormatting ] [ text "Clear" ]
            , button [ onClick AlignLeft ] [ text "Left" ]
            , button [ onClick AlignCenter ] [ text "Center" ]
            , button [ onClick AlignRight ] [ text "Right" ]
            , button [ onClick AddTab ] [ text "Tab" ]
            , button [ onClick ReplaceDashes ] [ text "emdash" ]
            , button [ onClick ClearOutput ] [ text "Clear Output" ]
            , button [ onClick (ExportAs "html") ] [ text "Export HTML" ]
            , button [ onClick (ExportAs "md") ] [ text "Export MD" ]
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
