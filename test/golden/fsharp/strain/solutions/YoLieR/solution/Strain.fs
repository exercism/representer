module Seq

let keep pred xs =
    seq {for e in xs do if pred e then yield e}

let discard pred xs =
    keep (pred >> not) xs