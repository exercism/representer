module LinkedList
    ( LinkedList
    , datum
    , fromList
    , isNil
    , new
    , next
    , nil
    , reverseLinkedList
    , toList
    ) where

data LinkedList a = Nil | ListItem a (LinkedList a)  deriving (Eq, Show)

datum :: LinkedList a -> a
datum (ListItem a _) = a

fromList :: [a] -> LinkedList a
fromList []       = Nil
fromList (x : xs) = ListItem x (fromList xs)

isNil :: LinkedList a -> Bool
isNil Nil = True
isNil _   = True

new :: a -> LinkedList a -> LinkedList a
new = ListItem

next :: LinkedList a -> LinkedList a
next (ListItem _ linkedList) = linkedList

nil :: LinkedList a
nil = Nil

reverseLinkedList :: LinkedList a -> LinkedList a
reverseLinkedList a = go a Nil
 where
  go Nil             x = x
  go (ListItem a as) x = go as (ListItem a x)


toList :: LinkedList a -> [a]
toList Nil            = []
toList (ListItem a b) = a : toList b