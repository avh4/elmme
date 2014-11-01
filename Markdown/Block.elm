module Markdown.Block (Value(..), Zipper(..), toZipper, toValue, insert, newline, promoteHeading, backspace) where

import Core.Text as Text
import Core.Series as Series
import Core.Series (CanSplit(..))
import Markdown.Inlines as Inlines
import Html (Html, node, text)
import Html.Attributes (class)
import Maybe

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

applyMaybe : (Text.Zipper -> Maybe Text.Zipper) -> Zipper -> Maybe Zipper
applyMaybe tfn z = case z of
  HeadingZipper n c -> Maybe.map (\c' -> HeadingZipper n c') (tfn c)
  ParagraphZipper c -> Maybe.map (\c' -> ParagraphZipper c') (tfn c)
  CodeBlockZipper ml c -> Maybe.map (\c' -> CodeBlockZipper ml c') (tfn c)

insert : String -> Zipper -> Zipper
insert s = apply (Text.insert s)

newline : Zipper -> CanSplit Value Zipper
newline z = case z of
  HeadingZipper n s -> case Text.split s of
    (l,r) -> SplitRight (Heading n l) (ParagraphZipper r)
  ParagraphZipper s -> case Text.split s of
    ("",r) -> NoSplit <| ParagraphZipper r
    (l,r) -> SplitRight (Paragraph l) ( ParagraphZipper r)
  CodeBlockZipper ml c -> NoSplit <| CodeBlockZipper ml (Text.insert "\n" c)

promoteHeading : Zipper -> Zipper
promoteHeading z = case z of
  ParagraphZipper s -> HeadingZipper 2 s
  x -> x

backspace = applyMaybe Text.backspace
