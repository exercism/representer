module Queens (boardString, canAttack) where

import Data.List (intercalate,intersperse)
import Data.Maybe (mapMaybe)
    
data Zipper a = Zipper [a] a [a]

instance Functor Zipper where
    fmap f (Zipper xs x ys) = Zipper (map f xs) (f x) (map f ys) 

type PlaneZ a = Zipper (Zipper a)
                       
toZipper :: [a] -> Zipper a
toZipper (x:xs) = Zipper [] x xs
toZipper [] = error "Zipper requires a non-empty list"
                  
fromZipper :: Zipper a -> [a]
fromZipper (Zipper xs x ys) = reverse xs ++ (x:ys)
                              
funcAtFocus :: (a -> a) -> PlaneZ a -> PlaneZ a
funcAtFocus f = zipFunc (zipFunc f)
    where zipFunc func (Zipper xs x ys) = Zipper xs (func x) ys

moveLeft :: Zipper a -> Zipper a
moveLeft (Zipper [] y ys) = Zipper [] y ys
moveLeft (Zipper (x:xs) y ys) = Zipper xs x (y:ys)

moveRight :: Zipper a -> Zipper a
moveRight (Zipper xs x []) = Zipper xs x []
moveRight (Zipper xs x (y:ys)) = Zipper (x:xs) y ys
    
moveX :: Int -> PlaneZ a -> PlaneZ a
moveX 0 zipper = zipper
moveX num zipper
    | num > 0 = moveX (num - 1) (fmap moveRight zipper)
    | otherwise = moveX (num + 1) (fmap moveLeft zipper)

moveY :: Int -> PlaneZ a -> PlaneZ a
moveY 0 zipper = zipper
moveY num zipper
    | num > 0 = moveY (num - 1) (moveRight zipper)
    | otherwise = moveY (num + 1) (moveLeft zipper)
             
prepare :: PlaneZ Char -> String
prepare board = intercalate "\n" (map (intersperse ' ' . fromZipper) (fromZipper board)) ++ "\n"

place :: Char -> (Int,Int) -> PlaneZ Char -> PlaneZ Char
place char (y,x) board = funcAtFocus (const char) position
    where position = moveY (y - getY board) $ moveX (x - getX board) board
          getX (Zipper _ (Zipper xs _ _) _) = length xs
          getY (Zipper ys _ _) = length ys

makeQueen :: Maybe (Int,Int) -> Char -> Maybe (Char,(Int,Int))
makeQueen (Just (x,y)) char = Just (char,(x,y))
makeQueen Nothing _ = Nothing
                                 
boardString :: Maybe (Int,Int) -> Maybe (Int,Int) -> String
boardString q1 q2 = prepare $ foldl (\acc (char,(y,x)) -> place char (y,x) acc) emptyBoard queens
    where emptyBoard = toZipper $ replicate 8 emptyLine
          emptyLine = toZipper $ replicate 8 '_'
          queens = mapMaybe (uncurry makeQueen) [(q1,'W'),(q2,'B')]

canAttack :: (Int,Int) -> (Int,Int) -> Bool
canAttack (x1,y1) (x2,y2)
    | x1 == x2 || y1 == y2 = True
    | abs (x1 - x2) == abs (y1 - y2) = True
    | otherwise = False