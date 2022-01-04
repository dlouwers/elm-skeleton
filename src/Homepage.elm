module Homepage exposing (page)

import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Tailwind.Utilities as Tw


page : String -> Html.Html msg
page userAgent =
    Html.div
        [ Attr.css [ Tw.container, Tw.mx_auto ] ]
        [ Html.text <| "Welcome to this demo, you are using " ++ userAgent ++ ". Please go to the Greeter page in the top menu to continue." ]
