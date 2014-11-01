module Core.Text (goRight, goLeft, goStart, goEnd, insert, backspace, split, Value, Zipper, toZipper, toValue) where

import String
import Maybe
import Regex (..)
import Html (Html, node, text)
import Html.Attributes (class)


type Value = String
type Zipper = (String,String)

toZipper : Value -> Zipper
toZipper v = (String.reverse v,"")

toValue : Zipper -> Value
toValue (left,right) = String.reverse left ++ right

goRight : Zipper -> Maybe Zipper
goRight (left,right) = String.uncons right
  |> Maybe.map (\(head,tail) -> (String.cons head left, tail))

goLeft : Zipper -> Maybe Zipper
goLeft (left,right) = String.uncons left
  |> Maybe.map (\(head,tail) -> (tail, String.cons head right))

goStart : Zipper -> Maybe Zipper
goStart (left,right) = Just ("", String.reverse left ++ right)

goEnd : Zipper -> Maybe Zipper
goEnd (left,right) = Just (String.reverse right ++ left, "")

insert : String -> Zipper -> Zipper
insert str (left,right) = (String.reverse str ++ left, right)

backspace : Zipper -> Maybe Zipper
backspace (left,right) = String.uncons left
  |> Maybe.map (\(_,tail) -> (tail, right))

split : Zipper -> (Value, Zipper)
split (left,right) = (String.reverse left, ("",right))
