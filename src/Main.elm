module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Css
import Homepage
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Evt
import Tailwind.Utilities as Tw
import Template as Tpl
import Url
import Url.Parser as Up exposing ((</>), Parser, oneOf, parse, string)



-- MAIN


main : Program String Model Msg
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
    = Home
    | SayHi
    | Hi String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Up.map Home Up.top
        , Up.map SayHi (Up.s "greet")
        , Up.map Hi (Up.s "greet" </> string)
        ]



-- MODEL


type alias Model =
    { route : Route
    , key : Nav.Key
    , name : Maybe String
    , userAgent : String
    }


init : String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let 
        route : Route
        route = Maybe.withDefault NotFound (parse routeParser url)
        name : Maybe String
        name = case route of
            Hi n -> Just n
            _ -> Nothing
    in
    ( { route = route, key = key, name = name, userAgent = flags }, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NameChanged String


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

        NameChanged name ->
            ( { model | name = Just name }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Home ->
            { title = "Home"
            , body =
                [ Html.toUnstyled <|
                    Tpl.mainFrame (Just "home") <|
                        [ Homepage.page model.userAgent ]
                ]
            }

        SayHi ->
            { title = "Greeter"
            , body =
                [ Html.toUnstyled <|
                    Tpl.mainFrame (Just "greeter") <|
                        [ nameInput NameChanged
                        , greetButton model.name
                        ]
                ]
            }

        Hi name ->
            { title = "Greeter"
            , body =
                [ Html.toUnstyled <|
                    Tpl.mainFrame (Just "greeter") <|
                        [ Html.text <| "Hi " ++ name ++ ", welcome to Elm"
                        ]
                ]
            }

        NotFound ->
            { title = "Sorry"
            , body =
                [ Html.toUnstyled <|
                    Tpl.mainFrame Nothing <|
                        [ Html.text "Sorry, I haven't found what you're looking for"
                        ]
                ]
            }


nameInput : (String -> msg) -> Html.Html msg
nameInput toMsg =
    Html.div [ Attr.css [ Tw.mb_3, Tw.pt_0 ] ]
        [ Html.input
            [ Attr.type_ "text"
            , Attr.placeholder "name"
            , Attr.css
                [ Tw.px_3
                , Tw.py_3
                , Tw.placeholder_gray_300
                , Tw.text_gray_600
                , Tw.relative
                , Tw.bg_white
                , Tw.rounded
                , Tw.text_sm
                , Tw.shadow
                , Tw.outline_none
                , Css.focus [ Tw.outline_none ]
                , Tw.w_full
                ]
            , Evt.onInput toMsg
            ]
            []
        ]


greetButton : Maybe String -> Html.Html msg
greetButton name =
    Html.a [ Attr.href <| "/greet/" ++ Maybe.withDefault "Elmo" name ]
        [ Html.button
            [ Attr.css
                [ Tw.bg_yellow_500
                , Tw.text_white
                , Css.active [ Tw.bg_yellow_600 ]
                , Tw.font_bold
                , Tw.uppercase
                , Tw.text_sm
                , Tw.px_6
                , Tw.py_3
                , Tw.rounded
                , Tw.shadow
                , Css.hover [ Tw.shadow_lg ]
                , Tw.outline_none
                , Css.focus [ Tw.outline_none ]
                , Tw.mr_1
                , Tw.mb_1
                , Tw.ease_linear
                , Tw.transition_all
                , Tw.duration_150
                ]
            , Attr.type_ "button"
            ]
            [ Html.text "Greet" ]
        ]
