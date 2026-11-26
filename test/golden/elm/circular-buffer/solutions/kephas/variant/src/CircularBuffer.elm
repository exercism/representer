module CircularBuffer exposing (CircularBuffer, clear, new, overwrite, read, write)


type alias CircularBuffer a
    = { size : Int
      , filled : Int
      , front : List a
      , back : List a
      }


new : Int -> CircularBuffer a
new size =
    CircularBuffer size 0 [] []


write : a -> CircularBuffer a -> Maybe (CircularBuffer a)
write element buffer  =
    if buffer.size == buffer.filled then
        Nothing
    else
        Just <| add element buffer


overwrite : a -> CircularBuffer a -> CircularBuffer a
overwrite element buffer =
    if buffer.filled < buffer.size then
        add element buffer
    else
        let balanced = balance buffer in
        case balanced.back of
            [] -> new buffer.size -- this can only happen in zero-sized buffer
            (_ :: rest) ->
                CircularBuffer buffer.size buffer.size (element :: balanced.front) rest 


read : CircularBuffer a -> Maybe ( a, CircularBuffer a )
read buffer =
    let {size, filled, front, back} = balance buffer in
    case back of
        [] -> Nothing
        (element :: rest) -> Just <| (element, CircularBuffer size (filled - 1) front rest)


clear : CircularBuffer a -> CircularBuffer a
clear {size} =
    new size

-- Utilities

add : a -> CircularBuffer a -> CircularBuffer a
add element {size, filled, front, back} =
    CircularBuffer size (filled + 1) (element :: front) back

balance : CircularBuffer a -> CircularBuffer a
balance {size, filled, front, back} =
    if back /= [] then
        CircularBuffer size filled [] <| List.reverse front
    else
        CircularBuffer size filled front back
