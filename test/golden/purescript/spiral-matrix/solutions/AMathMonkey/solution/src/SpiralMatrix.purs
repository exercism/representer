module Spiral
  ( spiral
  ) where

import Prelude
import Data.Maybe (fromMaybe)
import Data.List (List(..), modifyAt, updateAt, (!!), fromFoldable)
import Data.List.Lazy (replicate)
import Data.Tuple (Tuple(..))

data Direction
  = Up
  | Right
  | Down
  | Left

advance :: Int -> Int -> Direction -> Tuple Int Int
advance row col dir =
  case dir of
    Up -> Tuple (row - 1) col
    Down -> Tuple (row + 1) col
    Left -> Tuple row (col - 1)
    Right -> Tuple row (col + 1)

rotate :: Direction -> Direction
rotate dir =
  case dir of
    Right -> Down
    Down -> Left
    Left -> Up
    Up -> Right

spiral :: Int -> List (List Int)
spiral size =
  spiral' (fromFoldable (replicate size (fromFoldable (replicate size 0)))) 0 0 Right 1 size

spiral' :: List (List Int) -> Int -> Int -> Direction -> Int -> Int -> List (List Int)
spiral' grid row col dir i size =
  if i > (size * size) then grid
  else
    let
      newGrid = fromMaybe Nil (modifyAt row (\r -> fromMaybe Nil (updateAt col i r)) grid)
      Tuple row1 col1 = advance row col dir
    in if (fromMaybe 1 ((fromMaybe Nil (grid !! row1)) !! col1)) == 0
      then spiral' newGrid row1 col1 dir (i + 1) size
      else
        let
          newDir = rotate dir
          Tuple row2 col2 = advance row col newDir
        in spiral' newGrid row2 col2 newDir (i + 1) size
