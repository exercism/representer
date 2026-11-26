let encode mot =
  
  let n = String.length mot in 
  if n = 0 then ""
  else
    let s = ref "" in 
    let mult = ref 1 in
    let courant = ref mot.[0] in
    for i = 1 to n-1 do
      if mot.[i] = !courant then 
        mult := !mult +1
      else(
        if !mult <> 1 then
          s := !s ^ string_of_int !mult ^ String.make 1 !courant
        else
          s := !s ^ String.make 1 !courant;
        mult := 1;
        courant := mot.[i]
      )
    done;
    if !mult <> 1 then
      s := !s ^ string_of_int !mult ^ String.make 1 !courant
    else
      s := !s ^ String.make 1 !courant;
    !s;;
      

      
let decode mot =
let s = ref "" in 
  let n = String.length mot in 
  let mult = ref "" in 
  for i = 0 to n-1 do
    if mot.[i] >= '0' && mot.[i] <= '9' then 
      mult := !mult ^ String.make 1 mot.[i]
    else (
      if !mult <> "" then (
        let k = int_of_string !mult  in 
        for j = 0 to k-1 do 
          s := !s ^ String.make 1 mot.[i]
        done;
        mult := "";
      )
      else
        s := !s ^ String.make 1 mot.[i]
    ) 
  done;
  !s;;