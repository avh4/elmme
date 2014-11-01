module Core.Action (Action, nav, change, always, Result(..)) where

data Action v =
  Update v |
  Split [v] |
  Delete |
  EnterPrev | EnterNext |
  NoChange
