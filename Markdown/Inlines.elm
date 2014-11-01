module Markdown.Inlines (Value,Zipper, toZipper, toValue, insert, newline) where

import Core.Series as Series
import Markdown.Inline as Inline

type Value = Series.Value Inline.Value
type Zipper = Series.Zipper Inline.Value Inline.Zipper

toZipper : Value -> Zipper
toZipper = Series.toZipper Inline.toZipper

toValue : Zipper -> Value
toValue = Series.toValue Inline.toValue

insert : String -> Zipper -> Zipper
insert s = Series.apply (Inline.insert s)

newline : Zipper -> Zipper
newline = identity
