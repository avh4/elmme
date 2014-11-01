module Markdown.Render.Html (document) where

import Html (Html, text, node, toElement)
import Html.Attributes (class)

import Markdown.Document as Document
import Markdown.Block as Block
import Core.Series as Series
import Core.Text as Text
import String

document : Document.Zipper -> Html
document d = node "div" [] (Series.map block blockZipper d)

block : Block.Value -> Html
block v = case v of
  Block.Heading 1 s -> node "h1" [] [ text s ]
  Block.Heading 2 s -> node "h2" [] [ text s ]
  Block.Heading 3 s -> node "h3" [] [ text s ]
  Block.Heading _ s -> node "h4" [] [ text s ]
  Block.Paragraph s -> node "p" [] [ text s ]
  Block.CodeBlock ml s -> node "code" [] [ text s ]

blockZipper : Block.Zipper -> Html
blockZipper z = case z of
  Block.HeadingZipper 1 t -> node "h1" [] [ textZipper t ]
  Block.HeadingZipper 2 t -> node "h2" [] [ textZipper t ]
  Block.HeadingZipper 3 t -> node "h3" [] [ textZipper t ]
  Block.HeadingZipper _ t -> node "h4" [] [ textZipper t ]
  Block.ParagraphZipper t -> node "p" [] [ textZipper t ]
  Block.CodeBlockZipper ml t -> node "code" [] [ textZipper t ]

textZipper : Text.Zipper -> Html
textZipper (left,right) =
  node "span" []
    [ text (String.reverse left)
    , node "span" [ class "cursor" ] [ text "^" ]
    , text right
    ]
