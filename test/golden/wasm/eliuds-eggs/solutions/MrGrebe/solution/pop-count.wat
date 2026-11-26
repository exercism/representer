(module
  (func (export "eggCount") (param $number i32) (result i32)
    
  (local $n i32)
  (local $c i32)

  (local.set $n (local.get $number))

  (block $my_block

    local.get $n
    i32.eqz
    br_if $my_block
    
    (loop $my_loop
      
      local.get $n
      i32.const 2
      i32.rem_u
      i32.const 1
      i32.eq

      (if (then

        local.get $c
        i32.const 1
        i32.add
        local.set $c
      ))
        local.get $n
        i32.const 2
        i32.div_u

        local.set $n
        local.get $n
        i32.const 0
        i32.gt_u
        br_if $my_loop
                
      
      
    )
        
    )  
    
    local.get $c
  )
)
