module Tests.Core.Tests where

import ElmTest.Assertion (..)
import ElmTest.Test (..)

import Tests.Core.TextTest

suite = Suite "module Core"
  [ Tests.Core.TextTest.suite
  ]
