module rec CircularBuffer

[<Struct>]
type 'a Buffer = {size:int; ring:'a Ring.Ring}

type private Force = Force | Unforce

let mkCircularBuffer size = {size=size; ring= Ring.create size}

let clear buffer = {buffer with ring= Ring.clear buffer.ring}

let count buffer = Ring.count buffer.ring

let read b = 
    match count b with
    | 0 -> failwith "empty"
    | _ -> let (value, ring') = Ring.read b.ring
           value, {b with ring = ring'} 

let private innerWrite force value b = 
    let ring' = 
        match count b = b.size, force  with
        | true, Force   -> snd (Ring.read b.ring)
        | true, Unforce -> failwith "full"
        | _   , _       -> b.ring
    {b with ring = Ring.write value ring' }

let write value buffer = innerWrite Unforce value buffer

let forceWrite value buffer = innerWrite Force value buffer

module Ring =

    [<Struct>]
    type 'a Ring = {readx: uint; writex:uint; mask: uint; ring: 'a [] }
    
    let nextPow2 x = 
        let rec loop = function
            | p when p > x -> p
            | p -> loop (p <<< 1)    
        loop 1
    
    let clear b = {b with readx= 0u; writex= 0u}

    let count b = int (b.writex - b.readx)

    let create size = 
        let sizePow2 = nextPow2 size
        {readx= 0u; writex= 0u; mask= uint(sizePow2 - 1); ring= Array.zeroCreate sizePow2}
    
    let write value b = 
        b.ring.[int(b.writex &&& b.mask)] <- value
        {b with writex = b.writex + 1u }

    let read b = b.ring.[int(b.readx &&& b.mask)], {b with readx = b.readx + 1u }

