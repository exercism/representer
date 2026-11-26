(module
  (memory (export "mem") 1)
 
  (func (export "reverseString") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32) (local $max i32) (local $swap i32) (local $pos1 i32) (local $pos2 i32)
    (local.set $i (i32.const 0))
    (local.set $max (i32.div_u (local.get $length) (i32.const 2)))
    (loop
      (local.set $pos1 (i32.add (local.get $i) (local.get $offset)))
      (local.set $pos2 (i32.sub (i32.sub (i32.add (local.get $length) (local.get $offset)) (local.get $i)) (i32.const 1)))
      (local.set $swap (i32.load8_u (local.get $pos1)))
      (i32.store8
        (local.get $pos1)
        (i32.load8_u (local.get $pos2)))
      (i32.store8
        (local.get $pos2)
        (local.get $swap))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (i32.lt_u (local.get $i) (local.get $max))
      br_if 0
      )
    (return (local.get $offset) (local.get $length))
  )
)
