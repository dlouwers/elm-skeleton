module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- URL PARSER


type Route
    = Hi String
    | Bye String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.Parser.map NotFound Url.Parser.top
        , Url.Parser.map Hi (Url.Parser.s "greet" </> string)
        , Url.Parser.map Bye (Url.Parser.s "wave" </> string)
        ]



-- MODEL


type alias Model =
    { route : Route
    , key : Nav.Key
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { route = Maybe.withDefault NotFound (parse routeParser url), key = key }, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = Maybe.withDefault NotFound (parse routeParser url) }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Hi name ->
            { title = "Greeter"
            , body =
                [ text <| "Hi " ++ name ++ ", welcome to elm"
                , viewLink <| "/wave/" ++ name
                ]
            }

        Bye name ->
            { title = "Waver"
            , body =
                [ text <| "Bye " ++ name ++ ", see you again"
                , viewLink <| "/greet/" ++ name
                ]
            }

        NotFound ->
            { title = "Sorr"
            , body =
                [ text "Sorry, I haven't found what you're looking for"
                , viewLink <| "/greet/elm"
                ]
            }


viewLink : String -> Html msg
viewLink path =
    div [] [ a [ href path ] [ text path ] ]
