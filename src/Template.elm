module Template exposing (..)

import Css
import Css.Global
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw



-- NAVIGATION


globalStyles : Html.Html msg
globalStyles =
    Css.Global.global <|
        List.append
            [ Css.Global.html [ Tw.min_h_full ]
            , Css.Global.body [ Tw.min_h_full, Tw.bg_gray_100 ]
            ]
            Tw.globalStyles


topMenuItemSelected : String -> String -> Html.Html msg
topMenuItemSelected href label =
    Html.a
        [ Attr.href href
        , Attr.css
            [ Tw.bg_gray_900
            , Tw.text_white
            , Tw.px_3
            , Tw.py_2
            , Tw.rounded_md
            , Tw.text_sm
            , Tw.font_medium
            ]
        , Attr.attribute "aria-current" "page"
        ]
        [ Html.text label ]


topMenuItem : String -> String -> Html.Html msg
topMenuItem href label =
    Html.a
        [ Attr.href href
        , Attr.css
            [ Css.hover [ Tw.bg_gray_700, Tw.text_white ]
            , Tw.text_gray_300
            , Tw.px_3
            , Tw.py_2
            , Tw.rounded_md
            , Tw.text_sm
            , Tw.font_medium
            ]
        ]
        [ Html.text label ]


mainFrame : Maybe String -> List (Html.Html msg) -> Html.Html msg
mainFrame active content =
    Html.div [ Attr.css [ Tw.min_h_full ] ] <|
        [ globalStyles
        , Html.nav [ Attr.css [ Tw.bg_gray_800 ] ]
            [ Html.div
                [ Attr.css
                    [ Tw.max_w_7xl
                    , Tw.mx_auto
                    , Tw.px_4
                    , Breakpoints.lg [ Tw.px_8 ]
                    , Breakpoints.sm [ Tw.px_6 ]
                    ]
                ]
                [ Html.div
                    [ Attr.css
                        [ Tw.flex
                        , Tw.items_center
                        , Tw.justify_between
                        , Tw.h_16
                        ]
                    ]
                    [ Html.div
                        [ Attr.css [ Tw.flex, Tw.items_center ] ]
                        [ Html.div
                            [ Attr.css [ Tw.flex_shrink_0 ] ]
                            [ Html.img
                                [ Attr.css [ Tw.h_8, Tw.w_8 ]
                                , Attr.src "https://tailwindui.com/img/logos/workflow-mark-indigo-500.svg"
                                , Attr.alt "Workflow"
                                ]
                                []
                            ]
                        , Html.div
                            [ Attr.css
                                [ Tw.hidden
                                , Breakpoints.md [ Tw.block ]
                                ]
                            ]
                            [ Html.div
                                [ Attr.css
                                    [ Tw.ml_10
                                    , Tw.flex
                                    , Tw.items_baseline
                                    , Tw.space_x_4
                                    ]
                                ]
                                (makeMenu active)
                            ]
                        ]
                    ]
                ]
            ]
        , Html.main_
            []
            [ Html.div
                [ Attr.css
                    [ Tw.max_w_7xl
                    , Tw.mx_auto
                    , Tw.py_6
                    , Tw.px_4
                    , Breakpoints.lg [ Tw.px_8 ]
                    , Breakpoints.sm [ Tw.px_6 ]
                    ]
                ]
                content
            ]
        ]


makeMenu : Maybe String -> List (Html.Html msg)
makeMenu active =
    case active of
        Just "home" ->
            [ topMenuItemSelected "/" "Home"
            , topMenuItem "/greet" "Greeter"
            ]

        Just "greeter" ->
            [ topMenuItem "/" "Home"
            , topMenuItemSelected "/greet" "Greeter"
            ]

        Just _ ->
            [ topMenuItem "/" "Home"
            , topMenuItem "/greet" "Greeter"
            ]

        Nothing ->
            [ topMenuItem "/" "Home"
            , topMenuItem "/greet" "Greeter"
            ]
