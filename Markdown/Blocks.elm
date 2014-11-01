module Markdown.Blocks (Value,Zipper, toZipper, toValue, insert, newline, apply) where

import Core.Series as Series
import Markdown.Block as Block

type Value = Series.Value Block.Value
type Zipper = Series.Zipper Block.Value Block.Zipper

toZipper : Value -> Zipper
toZipper = Series.toZipper Block.toZipper

toValue : Zipper -> Value
toValue = Series.toValue Block.toValue

insert : String -> Zipper -> Zipper
insert s = Series.apply (Block.insert s)

newline : Zipper -> Zipper
newline = Series.applySplit Block.newline

apply : (Block.Zipper -> Block.Zipper) -> Zipper -> Zipper
apply = Series.apply