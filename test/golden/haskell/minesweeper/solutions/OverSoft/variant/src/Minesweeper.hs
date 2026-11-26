module Minesweeper (annotate) where

import Data.Char

annotate :: [String] -> [String]
annotate board = [[ calculateMine c x y | (x, c) <- zip [0..] str] | (y, str) <- zip [0..] board]
  where
    calculateMine c x y | c == '*'  = '*'
                        | otherwise = printOrEmpty (numMines x y)
    printOrEmpty num | num == 0  = ' '
                     | otherwise = intToDigit num
    numMines x y = mine (x - 1) (y - 1) + mine x (y - 1) + mine (x + 1) (y - 1) +
                   mine (x - 1) y                        + mine (x + 1) y       +
                   mine (x - 1) (y + 1) + mine x (y + 1) + mine (x + 1) (y + 1)
    mine x y     | x == -1 || y == -1 || x == length (board !! 0) || y == length board = 0
                 | ((board !! y) !! x) /= '*'                                          = 1
                 | otherwise                                                           = 0
