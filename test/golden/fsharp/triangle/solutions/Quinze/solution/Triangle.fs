module Triangle

let isTriangle (a: double) (b: double) (c: double) = 
    let maxIndex = List.findIndex (fun x -> x = List.max [a; b; c]) [a; b; c]
    let otherIndexes = List.removeAt maxIndex [0; 1; 2]
    if List.item maxIndex [a; b; c] < List.item otherIndexes[0] [a; b; c] + List.item otherIndexes[1] [a; b; c] then true else false

let equilateral (triangle: double list) = 
    let a, b, c = triangle[0], triangle[1], triangle[2]
    if isTriangle a b c then 
        if a = b && b = c then true else false 
    else false

let isosceles (triangle: double list) =
    let a, b, c = triangle[0], triangle[1], triangle[2]
    if isTriangle a b c then 
        if a = b || b = c || c = a then true else false 
    else false

let scalene (triangle: double list) = 
    let a, b, c = triangle[0], triangle[1], triangle[2]
    if isTriangle a b c then
        if equilateral triangle = false && isosceles triangle = false then true else false
    else false
