module Spiral
  ( spiral
  ) where

import Prelude
import Data.Array as Array
import Data.List (List(..))
import Data.List as List
import Data.Maybe

spiral :: Int -> List (List Int)
spiral 0 = Nil
spiral size = arrayToList $ fillSpiral $ newMatrix size

newMatrix :: Int -> Array (Array Int)
newMatrix size = Array.replicate size (Array.replicate size 0)

fillSpiral :: Array (Array Int) -> Array (Array Int)
fillSpiral matrix = go 0 0 1 0 1 matrix
  where
    size = Array.length matrix
    go :: Int -> Int -> Int -> Int -> Int -> Array (Array Int) -> Array (Array Int)
    go row col num rowDirection colDirection mat
      | num > size * size = mat
      | otherwise = 
          let
            -- Update the matrix
            updatedMat = setValueAt row col num mat
            
            -- Calculate the next row and column positions
            nextRow = row + rowDirection
            nextCol = col + colDirection
            
            -- Check if the next position is out of bounds
            outOfBounds = nextRow < 0 || nextRow >= size || nextCol < 0 || nextCol >= size
            
            -- Check if the next position is already occupied
            currentVal = fromMaybe 0 (getValueAt nextRow nextCol updatedMat)
            occupied = not outOfBounds && currentVal /= 0
          in
            if outOfBounds || occupied
            -- If out of bounds or occupied, change direction
            then go (row - colDirection) (col + (-rowDirection)) (num + 1) colDirection (-rowDirection) updatedMat
            -- Otherwise, move to the next position
            else go nextRow nextCol (num + 1) rowDirection colDirection updatedMat

getValueAt :: Int -> Int -> Array (Array Int) -> Maybe Int
getValueAt row col matrix = Array.index matrix row >>= \rowArray -> Array.index rowArray col

setValueAt :: Int -> Int -> Int -> Array (Array Int) -> Array (Array Int)
setValueAt row col num matrix = 
  let
    rowToUpdate = fromMaybe (Array.replicate (Array.length matrix) 0) (Array.index matrix row)
    updatedRow = fromMaybe rowToUpdate (Array.updateAt col num rowToUpdate)
  in
    fromMaybe matrix (Array.updateAt row updatedRow matrix)

arrayToList :: Array (Array Int) -> List (List Int)
arrayToList matrix = List.fromFoldable (map List.fromFoldable matrix)