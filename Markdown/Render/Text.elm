module Markdown.Render.Text (document) where

import Markdown.Document as Document
import Markdown.Blocks as Blocks
import Markdown.Block as Block

document : Document.Zipper -> String
document d = join "\n\n" <| map block (Blocks.toValue d)

codeBlockStart ml = case ml of
  Just lang -> "```" ++ lang ++ "\n"
  Nothing -> "```\n"

block : Block.Value -> String
block v = case v of
  Block.Heading n s -> "# " ++ s
  Block.Paragraph s -> s
  Block.CodeBlock ml s -> (codeBlockStart ml) ++ s ++ "\n```"