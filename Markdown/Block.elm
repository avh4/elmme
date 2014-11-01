module Markdown.Block (Value(..), Zipper(..), toZipper, toValue, insert, newline, promoteHeading) where

import Core.Text as Text
import Core.Series as Series
import Core.Series (CanSplit(..))
import Markdown.Inlines as Inlines
import Html (Html, node, text)
import Html.Attributes (class)

data Value
  = Heading Int Text.Value -- level, content
  | Paragraph Text.Value -- content
  | CodeBlock (Maybe Text.Value) Text.Value -- language, content

data Zipper
  = HeadingZipper Int Text.Zipper
  | ParagraphZipper Text.Zipper
  | CodeBlockZipper (Maybe Text.Value) Text.Zipper

toZipper : Value -> Zipper
toZipper v = case v of
  Heading n c -> HeadingZipper n (Text.toZipper c)
  Paragraph c -> ParagraphZipper (Text.toZipper c)
  CodeBlock ml c -> CodeBlockZipper ml (Text.toZipper c)

toValue : Zipper -> Value
toValue z = case z of
  HeadingZipper n c -> Heading n (Text.toValue c)
  ParagraphZipper c -> Paragraph (Text.toValue c)
  CodeBlockZipper ml c -> CodeBlock ml (Text.toValue c)

apply : (Text.Zipper -> Text.Zipper) -> Zipper -> Zipper
apply tfn z = case z of
  HeadingZipper n c -> HeadingZipper n (tfn c)
  ParagraphZipper c -> ParagraphZipper (tfn c)
  CodeBlockZipper ml c -> CodeBlockZipper ml (tfn c)

insert : String -> Zipper -> Zipper
insert s = apply (Text.insert s)

newline : Zipper -> CanSplit Value Zipper
newline z = case z of
  HeadingZipper n s -> case Text.split s of
    (l,r) -> SplitRight (Heading n l) (ParagraphZipper r)
  ParagraphZipper s -> case Text.split s of
    (l,r) -> SplitRight (Paragraph l) ( ParagraphZipper r)
  CodeBlockZipper ml c -> NoSplit <| CodeBlockZipper ml (Text.insert "\n" c)

promoteHeading : Zipper -> Zipper
promoteHeading z = case z of
  ParagraphZipper s -> HeadingZipper 2 s
  x -> x

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
