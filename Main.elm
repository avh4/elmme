module Main where

import Html (Html, text, node, toElement)
import Html.Attributes (class)

import String
import Keys
import Char
import Debug
import Markdown.Document as Document
import Markdown.Block as Block
import Markdown.Blocks as Blocks
import Markdown.Render.Html as RenderHtml
import Markdown.Render.Text as RenderText
import App

-- INPUT

toCommand : Keys.KeyInput -> App.Command
toCommand k = case k of
  Keys.Enter -> App.Enter
  Keys.Character s -> App.Type s
  Keys.Backspace -> App.Backspace
  x -> App.Type <| show x

-- RENDER


state = foldp App.step App.model (toCommand <~ Keys.lastPressed)

editor : Document.Zipper -> Element
editor d = toElement 400 400 (RenderHtml.document d)

source : Document.Zipper -> Element
source d = d |> RenderText.document |> plainText

mainView : Document.Zipper -> Element
mainView d = flow right
  [ editor d
  , source d
  ]

main = (mainView <~ state)
