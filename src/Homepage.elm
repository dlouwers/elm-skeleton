module Homepage exposing (page)

import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Tailwind.Utilities as Tw


page : Html.Html msg
page =
    Html.div
        [ Attr.css [ Tw.container, Tw.mx_auto ] ]
        [ Html.text "Welcome to this demo. Please go to the Greeter page in the top menu to continue" ]
