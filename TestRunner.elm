module Main where

import ElmTest.Assertion (..)
import ElmTest.Test (..)

import ElmTest.Run as Run
import ElmTest.Runner.Element as Element
import ElmTest.Runner.String  as String

import Tests.AppTest
import Tests.Core.Tests

suite = Suite "elmme"
  [ Tests.AppTest.suite
  , Tests.Core.Tests.suite
  ]

main = Element.runDisplay suite