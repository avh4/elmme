module Tests.AppTest where

import ElmTest.Assertion (..)
import ElmTest.Test (..)

import App
import App (Command(..))
import Markdown.Block as Block
import Markdown.Blocks as Blocks
import Markdown.Inline as Inline

test1 = test "type some things" <|
  Blocks.toValue (foldl App.step App.model
    [ Type "Elm"
    , Enter
    , Type "A functional reactive language for interactive applications"
    , Enter
    , Cmd "h"
    , Type "Functional"
    , Enter
    , Type "Features like immutability and type inference help you write code that is short, fast, and maintainable. Elm makes them easy to learn too."
    ])
  `assertEqual`
  [ Block.Heading 1 "Elm"
  , Block.Paragraph "A functional reactive language for interactive applications"
  , Block.Heading 2 "Functional"
  , Block.Paragraph "Features like immutability and type inference help you write code that is short, fast, and maintainable. Elm makes them easy to learn too."
  ]

suite = Suite "module App"
  [ test1
  ]
