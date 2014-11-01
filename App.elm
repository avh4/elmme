module App where

import Markdown.Blocks as Blocks
import Markdown.Block as Block
import Markdown.Inline as Inline
import Debug

data Command
  = Type String
  | Enter
  | Backspace
  | Cmd String

model : Blocks.Zipper
model = Blocks.toZipper [Block.Heading 1 ""]

step : Command -> Blocks.Zipper -> Blocks.Zipper
step c m = case c of
  Type str -> Blocks.insert str m
  Enter -> Blocks.newline m
  Backspace -> Blocks.applyMaybe Block.backspace m
  Cmd "h" -> Blocks.apply Block.promoteHeading m
  x -> fst (m, Debug.log "Unrecognized command" x)
