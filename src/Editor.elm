module Editor exposing (Model, Msg(..), update, wordCount)

-- MODEL


type alias Model =
    { content : String
    , searchTerm : String
    }



-- MSG


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
    | UpdateSearch String
    | HighlightSearch



-- UPDATE (pure - no ports)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUpdatedText newText ->
            ( { model | content = newText }, Cmd.none )

        ClearOutput ->
            ( { model | content = "" }, Cmd.none )

        UpdateSearch term ->
            ( { model | searchTerm = term }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- WORD COUNT


wordCount : String -> Int
wordCount content =
    content
        |> String.words
        |> List.length
