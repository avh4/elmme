module Markdown.Block (Value(..), Zipper(..), toZipper, toValue, insert) where

import Core.Text as Text
import Core.Series as Series
import Markdown.Inlines as Inlines
import Html (Html, node, text)
import Html.Attributes (class)

data Value
  = Heading Int Inlines.Value -- level, content
  | Paragraph Inlines.Value -- content
  | CodeBlock (Maybe Text.Value) Text.Value -- language, content

data Zipper
  = HeadingZipper Int Inlines.Zipper
  | ParagraphZipper Inlines.Zipper
  | CodeBlockZipper (Maybe Text.Value) Text.Zipper

toZipper : Value -> Zipper
toZipper v = case v of
  Heading n c -> HeadingZipper n (Inlines.toZipper c)
  Paragraph c -> ParagraphZipper (Inlines.toZipper c)
  CodeBlock ml c -> CodeBlockZipper ml (Text.toZipper c)

toValue : Zipper -> Value
toValue z = case z of
  HeadingZipper n c -> Heading n (Inlines.toValue c)
  ParagraphZipper c -> Paragraph (Inlines.toValue c)
  CodeBlockZipper ml c -> CodeBlock ml (Text.toValue c)

apply : (Inlines.Zipper -> Inlines.Zipper) -> (Text.Zipper -> Text.Zipper) -> Zipper -> Zipper
apply ifn tfn z = case z of
  HeadingZipper n c -> HeadingZipper n (ifn c)
  ParagraphZipper c -> ParagraphZipper (ifn c)
  CodeBlockZipper ml c -> CodeBlockZipper ml (tfn c)

insert : String -> Zipper -> Zipper
insert s = apply (Inlines.insert s) (Text.insert s)

--
-- type Cursor = Span.Cursor
--
-- update : (Block, Cursor) -> String -> Block
-- update (value, cursor) char = case value of
--   Heading h span -> Heading h <| Span.update (span, cursor) char
--   Paragraph span -> Paragraph <| Span.update (span, cursor) char
--   CodeBlock lang s -> CodeBlock lang <| Span.updateString (s, cursor) char
--
-- move (value, cursor) char = case value of
--   Heading _ span -> Span.move (span, cursor) char
--   Paragraph span -> Span.move (span, cursor) char
--   CodeBlock _ s -> Span.moveString (s, cursor) char
--
-- render : Block -> Maybe Cursor -> Html
-- render block mc = case block of
--   Heading 1 span -> node "h1" [] [ Span.render span mc ]
--   Heading _ span -> node "h1" [] [ Span.render span mc ]
--   Paragraph span -> node "p" [] [ Span.render span mc ]
--   CodeBlock _ s -> node "code" [] [ text s ] -- TODO render cursor
