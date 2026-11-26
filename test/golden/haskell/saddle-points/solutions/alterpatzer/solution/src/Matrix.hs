module Matrix (saddlePoints) where

import Data.Array (Array, bounds, (!))

rows :: Array (Int, Int) e -> Int
rows = fst . snd . bounds

columns :: Array (Int, Int) e -> Int 
columns = snd . snd . bounds

row :: Array (Int, Int) e -> Int -> [e]
row a r = [a ! (r, c) | c <- [1..(columns a)]]

column :: Array (Int, Int) e -> Int -> [e]
column a c = [a ! (r, c) | r <- [1..(rows a)]]

rmax :: Array (Int, Int) Int -> Int -> Int
rmax a r = foldl1 max $ row a r

cmin :: Array (Int, Int) Int -> Int -> Int
cmin a c = foldl1 min $ column a c

saddlePoints :: Array (Int, Int) Int -> [(Int, Int)]
saddlePoints matrix =
    [(r, c) | r <- [1..(rows matrix)], c <- [1..(columns matrix)],
              matrix ! (r, c) == rmax matrix r &&
              matrix ! (r, c) == cmin matrix c]

