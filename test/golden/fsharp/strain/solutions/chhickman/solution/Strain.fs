module Seq

let keep pred xs = 
    seq {for n in xs do if pred n then yield n}


let discard pred xs = 
    seq {for n in xs do if not (pred n) then yield n}
