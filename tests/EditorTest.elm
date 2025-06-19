module EditorTest exposing (all)

import Editor exposing (Model, Msg(..), update, wordCount)
import Expect exposing (Expectation)
import Test exposing (..)


initialModel : Model
initialModel =
    { content = "Hello world", searchTerm = "" }


all : Test
all =
    describe "Editor module"
        [ test "GotUpdatedText updates content" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update (GotUpdatedText "New content") initialModel
                in
                Expect.equal updated.content "New content"
        , test "ClearOutput clears content" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update ClearOutput initialModel
                in
                Expect.equal updated.content ""
        , test "UpdateSearch updates search term" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update (UpdateSearch "test") initialModel
                in
                Expect.equal updated.searchTerm "test"
        , test "Other Msgs do not change model" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update FormatBold initialModel
                in
                Expect.equal updated initialModel
        , test "wordCount counts words correctly" <|
            \_ ->
                let
                    result =
                        wordCount "one two three"
                in
                Expect.equal result 3
        , test "wordCount returns 1 for empty string" <|
            \_ -> Expect.equal (wordCount "") 1
        , test "wordCount ignores multiple spaces" <|
            \_ -> Expect.equal (wordCount "one   two") 2
        , test "wordCount counts newlines and tabs as spaces" <|
            \_ -> Expect.equal (wordCount "one\ntwo\tthree") 3
        , test "init returns empty model and no cmd" <|
            \_ ->
                let
                    ( model, cmd ) =
                        Editor.update (GotUpdatedText "") { content = "test", searchTerm = "test" }
                in
                Expect.equal model { content = "", searchTerm = "test" }
        , test "ClearOutput preserves searchTerm" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update ClearOutput initialModel
                in
                Expect.equal updated.searchTerm initialModel.searchTerm
        , test "GotUpdatedText preserves searchTerm" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update (GotUpdatedText "new content") initialModel
                in
                Expect.equal updated.searchTerm initialModel.searchTerm
        , test "UpdateSearch preserves content" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update (UpdateSearch "new search") initialModel
                in
                Expect.equal updated.content initialModel.content
        ]
