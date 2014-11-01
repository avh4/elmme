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
