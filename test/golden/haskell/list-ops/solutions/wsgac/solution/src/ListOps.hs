module ListOps
  ( length,
    reverse,
    map,
    filter,
    foldr,
    foldl',
    (++),
    concat,
  )
where

import Prelude hiding
  ( concat,
    filter,
    foldr,
    length,
    map,
    reverse,
    (++),
  )

foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' f z xs = tailFoldl z xs
  where
    tailFoldl acc [] = acc
    tailFoldl acc (x : xs) = acc `seq` tailFoldl (f acc x) xs

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z xs = tailFoldr z $ reverse xs
  where
    tailFoldr acc [] = acc
    tailFoldr acc (x : xs) = tailFoldr (f x acc) xs

length :: [a] -> Int
length = tailLength 0
  where
    tailLength acc [] = acc
    tailLength acc (_ : tail) = tailLength (acc + 1) tail

reverse :: [a] -> [a]
reverse = tailReverse []
  where
    tailReverse acc [] = acc
    tailReverse acc (x : xs) = tailReverse (x : acc) xs

map :: (a -> b) -> [a] -> [b]
map f = tailMap []
  where
    tailMap acc [] = reverse acc
    tailMap acc (x : xs) = tailMap (f x : acc) xs

filter :: (a -> Bool) -> [a] -> [a]
filter p = tailFilter []
  where
    tailFilter acc [] = reverse acc
    tailFilter acc (x : xs) = tailFilter acc' xs
      where
        acc' = if (p x) then (x : acc) else acc

(++) :: [a] -> [a] -> [a]
xs ++ ys = tailAppend ys $ reverse xs
  where
    tailAppend acc [] = acc
    tailAppend acc (x : xs) = tailAppend (x : acc) xs

concat :: [[a]] -> [a]
concat = foldr (++) []
