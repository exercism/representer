module BinarySearch

let find (input: 'a array) value =
    let rec loop startPoint endPoint =
        if startPoint = endPoint - 1 then
            if input[startPoint] = value then Some startPoint else None
        else
            let midPoint = (startPoint + endPoint) / 2

            match input[midPoint] with
            | x when x = value -> Some midPoint
            | x when x < value -> loop midPoint endPoint
            | _ -> loop startPoint midPoint

    match Array.length input with
    | 0 -> None
    | endPoint -> loop 0 endPoint
