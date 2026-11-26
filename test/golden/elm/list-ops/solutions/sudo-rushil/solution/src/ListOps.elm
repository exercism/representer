module ListOps exposing
    ( append
    , concat
    , filter
    , foldl
    , foldr
    , length
    , map
    , reverse
    )


length : List a -> Int
length list =
    List.length list


reverse : List a -> List a
reverse list =
    List.reverse list


foldl : (a -> b -> b) -> b -> List a -> b
foldl f acc list =
    List.foldl f acc list


foldr : (a -> b -> b) -> b -> List a -> b
foldr f acc list =
    List.foldr f acc list


map : (a -> b) -> List a -> List b
map f list =
    List.map f list


filter : (a -> Bool) -> List a -> List a
filter f list =
    List.filter f list


append : List a -> List a -> List a
append xs ys =
    List.append xs ys


concat : List (List a) -> List a
concat list =
    List.concat list
