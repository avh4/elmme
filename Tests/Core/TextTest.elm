module Tests.Core.TextTest where

import ElmTest.Assertion (..)
import ElmTest.Test (..)

import Core.Text as Text

goTests = Suite "go left/right"
  [ Text.goRight ("","a") `equals` Just ("a","")
  , Text.goRight ("a","b") `equals` Just ("ba","")
  , Text.goRight ("","ab") `equals` Just ("a","b")
  , Text.goRight ("a","") `equals` Nothing
  , Text.goLeft ("a","") `equals` Just ("","a")
  , Text.goLeft ("ba","") `equals` Just ("a","b")
  , Text.goLeft ("a","b") `equals` Just ("","ab")
  , Text.goLeft ("","a") `equals` Nothing
  , Text.goStart ("ba","cd") `equals` Just ("","abcd")
  , Text.goEnd ("ba","cd") `equals` Just ("dcba","")
  ]

suite = Suite "module Core.Text"
  [ goTests
  , Suite "insert"
    [ Text.insert "x" ("","") `equals` ("x","")
    , Text.insert "x" ("a","b") `equals` ("xa","b")
    , Text.insert "xy" ("a","b") `equals` ("yxa","b")
    ]
  , Suite "backscape"
    [ Text.backspace ("a","") `equals` Just ("","")
    , Text.backspace ("a","b") `equals` Just ("","b")
    , Text.backspace ("","a") `equals` Nothing
    ]
  , Suite "split"
    [ Text.split ("a","b") `equals` ("a",("","b"))
    , Text.split ("","b") `equals` ("",("","b"))
    , Text.split ("a","") `equals` ("a",("",""))
    ]
  ]
