module Core.Action (Action, nav, change, always, Result(..)) where

data Action v =
  Update v |
  Split [v] |
  Delete |
  EnterPrev | EnterNext |
  NoChange

-- type Action v c = (v -> c -> Result v c)

-- apply : (a -> Action b) -> (b -> Action c) -> a -> Action c
-- apply fa fb a = case fa a of
--   Update b -> fb b
--   Split bs -> Split (map fb bs) -- needs to flatten the results
--   x -> x

-- nav : (v -> c -> c) -> Action v c
-- nav fn = \v c -> Update v (fn v c)
--
-- change : (v -> c -> v) -> Action v c
-- change fn = \v c -> Update (fn v c) c
--
-- always : Result v c -> Action v c
-- always r = \_ _ -> r
