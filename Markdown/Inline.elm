module Markdown.Inline (Value(..), Zipper(..), toZipper, toValue, insert) where

import String
import Html (Html, node, text)
import Html.Attributes (class)
import Core.Text as Text
import Maybe

data Value
  = Str Text.Value
  | Strong Text.Value
  | Emph Text.Value
  | Link Text.Value Text.Value
  | Code Text.Value

data Zipper
  = StrZipper Text.Zipper
  | StrongZipper Text.Zipper
  | EmphZipper Text.Zipper
  | LinkHrefZipper Text.Zipper Text.Value
  | LinkLabelZipper Text.Value Text.Zipper
  | CodeZipper Text.Zipper

toZipper : Value -> Zipper
toZipper v = case v of
  Str s -> StrZipper (Text.toZipper s)
  Strong s -> StrongZipper (Text.toZipper s)
  Emph s -> EmphZipper (Text.toZipper s)
  Link href s -> LinkLabelZipper href (Text.toZipper s)
  Code s -> CodeZipper (Text.toZipper s)

toValue : Zipper -> Value
toValue z = case z of
  StrZipper s -> Str (Text.toValue s)
  StrongZipper s -> Strong (Text.toValue s)
  EmphZipper s -> Emph (Text.toValue s)
  LinkHrefZipper href s -> Link (Text.toValue href) s
  LinkLabelZipper href s -> Link href (Text.toValue s)
  CodeZipper s -> Code (Text.toValue s)

apply : (Text.Zipper -> Text.Zipper) -> Zipper -> Zipper
apply fn z = case z of
  StrZipper s -> StrZipper (fn s)
  StrongZipper s -> StrongZipper (fn s)
  EmphZipper s -> EmphZipper (fn s)
  LinkHrefZipper href s -> LinkHrefZipper (fn href) s
  LinkLabelZipper href s -> LinkLabelZipper href (fn s)
  CodeZipper s -> CodeZipper (fn s)

insert : String -> Zipper -> Zipper
insert s = apply (Text.insert s)

-- do : Zipper v z -> Maybe (Zipper v z)
-- do z = Just z -- case z of
-- --   StrZipper tz -> Maybe.map StrZipper <| textFn tz
-- --   StrongZipper tz -> Maybe.map StrongZipper <| textFn tz
-- --   EmphZipper tz -> Maybe.map EmphZipper <| textFn tz
-- --   LinkHrefZipper tz v -> Maybe.map (\x -> LinkHrefZipper x v) (textFn tz)
-- --   LinkLabelZipper v tz -> Maybe.map (\x -> LinkLabelZipper x v) (textFn tz)
-- --   CodeZipper tz -> Maybe.map CodeZipper (textFn tz)
--
-- goLeft : Zipper Text.Value Text.Zipper -> Maybe (Zipper Text.Value Text.Zipper)
-- goLeft = do Text.goLeft

-- type StringCursor = Int
-- type Cursor = Int
--
-- stringer =
--   { update = \(value, selection) char ->
--     (String.left selection value)
--     ++ char
--     ++ (String.dropLeft selection value)
--   , move = \(value, selection) char ->
--     selection + 1 -- TODO lenght of char
--   }
--
-- updateString = stringer.update
--
-- moveString = stringer.move
--
-- update : (Span, Cursor) -> String -> Span
-- update (value, selection) char = case value of
--   Plain s -> Plain <| stringer.update (s, selection) char
--
-- move : (Span, Cursor) -> String -> Cursor
-- move (value, selection) char = case value of
--   Plain s -> stringer.move (s, selection) char
--
-- render : Span -> Maybe Cursor -> Html
-- render span mc = case span of
--   Plain string -> case mc of
--     Just cursor -> node "span" [] [
--       text <| String.left cursor string,
--       node "span" [ class "cursor" ] [ text "^" ],
--       text <| String.dropLeft cursor string ]
--     Nothing -> node "span" [] [ text string ]
--
