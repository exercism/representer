let primes (n : int) : int list =
    let numbers = Array.make (n+1) true in
    numbers.(0) <- false ; numbers.(1) <- false;
    let rec adder(accu : int list)(counter : int) : int list = 
    if counter > n then List.rev accu
    else if numbers.(counter) then 
            let i = ref (counter lsl 1) in
            while !i < n do begin
              numbers.(!i) <- false;
              i := !i +counter;
              end done;
              adder (counter :: accu) (counter +1)
          else adder accu (counter+1)
    in adder [] 2;;
    