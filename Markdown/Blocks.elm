module Markdown.Blocks (Value,Zipper,toZipper,toValue,insert) where

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
