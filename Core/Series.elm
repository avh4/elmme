module Core.Series (Value, Zipper, toZipper ,toValue, apply, CanSplit(..), applySplit) where

type Value a = [a]
type Zipper a z = ([a],z,[a])

data CanSplit v z
  = SplitRight v z
  | NoSplit z

toZipper : (a -> z) -> Value a -> Zipper a z
toZipper fn (a::tail) = ([],fn a,tail)

toValue : (z -> a) -> Zipper a z -> Value a
toValue fn (left,cur,right) = reverse left ++ [fn cur] ++ right

apply : (z -> z) -> Zipper a z -> Zipper a z
apply fn (left,cur,right) = (left,fn cur,right)

applySplit : (z -> CanSplit a z) -> Zipper a z -> Zipper a z
applySplit fn (left,cur,right) = case fn cur of
  SplitRight l v -> (l :: left, v, right)
  NoSplit v -> (left, v, right)

--
-- type Value a = [a]
-- type Cursor a = (Int, a)
-- type Subs a = {child:a}
--
-- cursor n c = (n, c)
--
-- replaceAt : a -> Int -> [a] -> [a]
-- replaceAt a index list =
--   indexedMap (\i item -> if i == index then a else item) list
--
-- at : Int -> [a] -> a
-- at i list = list |> drop i |> head
--
-- -- TODO: instead of passing in nextCursor/prevCursor eagerly, can we flip it around so that there is an ActionResult that has a function : c -> Array.Cursor c
-- do : c -> (v -> c) -> Action v c -> Action [v] (Cursor c)
-- do nextCursor prevCursor action vs (i,c) = case action (at i vs) c of
--   Action.Update newV newC -> Action.Update (replaceAt newV i vs) (i,newC)
--   Action.Split newVs newI newC -> Action.Update ((take i vs) ++ newVs ++ (drop (i+1) vs)) (newI+i, newC)
--   Action.Delete -> if
--     | length vs > 1 -> Action.Update ((take i vs) ++ (drop (i+1) vs)) (min i <| -2+length vs,c)
--     | otherwise -> Action.Delete
--   Action.EnterNext -> if
--     | length vs > i+1 -> Action.Update vs (i+1, nextCursor)
--     | otherwise -> Action.EnterNext
--   Action.EnterPrev -> if
--     | i > 0 -> Action.Update vs (i-1, prevCursor (at (i-1) vs))
--     | otherwise -> Action.EnterPrev
--   Action.NoChange -> Action.NoChange
--
-- split_ : (v -> c -> (v, v, c)) -> Action v c
-- split_ fn = \v c -> case fn v c of
--   (v1, v2, innerC) -> Action.Split [v1, v2] 1 innerC
--
-- split : c -> (v -> c) -> (v -> c -> (v, v, c)) -> Action [v] (Cursor c)
-- split nextCursor prevCursor fn = do nextCursor prevCursor (split_ fn)
--
-- render : (val -> Maybe cur -> out) -> [val] -> Maybe (Cursor cur) -> [out]
-- render fn list msel = case msel of
--   Just (n, c) -> indexedMap (\i x -> fn x (if i==n then Just c else Nothing)) list
--   Nothing -> map (\x -> fn x Nothing) list
--
--
-- ---- JSON
--
-- walk : (Value b -> c) -> Subs (a -> b) -> Value a -> c
-- walk wrapFn {child} list = wrapFn <| map child list
--
-- toJson : (a -> String) -> [a] -> String
-- toJson fn = walk (\vs -> "[" ++ (join "," vs) ++ "]") {child=fn}
