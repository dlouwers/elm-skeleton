module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Css
import Css.Global
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw
import Url
import Url.Parser as Up exposing ((</>), Parser, int, map, oneOf, parse, s, string)



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
        [ Up.map NotFound Up.top
        , Up.map Hi (Up.s "greet" </> string)
        , Up.map Bye (Up.s "wave" </> string)
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
                List.map Html.toUnstyled <|
                    [ Html.text <| "Hi " ++ name ++ ", welcome to elm"
                    , viewLink <| "/wave/" ++ name
                    ]
            }

        Bye name ->
            { title = "Waver"
            , body =
                List.map Html.toUnstyled <|
                    [ Html.text <| "Bye " ++ name ++ ", see you again"
                    , viewLink <| "/greet/" ++ name
                    ]
            }

        NotFound ->
            { title = "Sorry"
            , body =
                List.map Html.toUnstyled <|
                    [ Html.text "Sorry, I haven't found what you're looking for"
                    , viewLink <| "/greet/elm"
                    ]
            }


viewLink : String -> Html.Html msg
viewLink path =
    Html.div [] [ Html.a [ Attr.href path ] [ Html.text path ] ]
