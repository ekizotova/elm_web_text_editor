port module Main exposing (main)

import Browser
import Editor exposing (Model, Msg(..), update, wordCount)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Lazy as Html



-- PORTS


port applyFormat : String -> Cmd msg


port receiveUpdatedText : (String -> msg) -> Sub msg


port exportContent : String -> Cmd msg


port highlightText : String -> Cmd msg



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { content = "", searchTerm = "" }, Cmd.none )



-- WRAPPED UPDATE


updateWithPorts : Msg -> Model -> ( Model, Cmd Msg )
updateWithPorts msg model =
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

        ExportAs format ->
            ( model, exportContent (format ++ "::" ++ model.content) )

        HighlightSearch ->
            ( model, highlightText model.searchTerm )

        _ ->
            Editor.update msg model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Elm Text Editor" ]
        , h3 [] [ text " " ]
        , div []
            [ input
                [ placeholder "Search term..."
                , value model.searchTerm
                , onInput UpdateSearch
                ]
                []
            , button [ onClick HighlightSearch ] [ text "Highlight" ]
            ]
        , h3 [] [ text " " ]
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
        , div []
            [ text
                ("Words: "
                    ++ String.fromInt (wordCount model.content)
                )
            ]
        , h3 [] [ text "Aktuální HTML výstup" ]
        , div [ style "margin-top" "1em" ]
            [ h3 [] [ text "Preview:" ]
            , div [ style "background" "#f9f9f9" ]
                [ Html.lazy Html.text model.content ]
            ]
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
        , update = updateWithPorts
        , view = view
        , subscriptions = subscriptions
        }
