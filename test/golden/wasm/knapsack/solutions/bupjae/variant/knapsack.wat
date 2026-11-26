(module
  (memory (export "mem") 1)

  ;; Determine the maximum total value that can be carried
  ;;
  ;; @param {i32} itemsCount - The number of items
  ;; @param {i32} capacity - How much weight the knapsack can carry
  ;; @returns {i32} the maximum value
  ;;
  (func (export "maximumValue") (param $itemsCount i32) (param $capacity i32) (result i32)
    (local $bag_start i32)
    (local $bag_end i32)
    (local $bag_pointer i32)
    (local $item_pointer i32)
    (local $item_weight i32)
    (local $item_value i32)
    (local $t i32)
    (local $u i32)
    (local $r i32)

    i32.const 0
    local.tee $item_pointer
    local.set $r

    local.get $itemsCount
    i32.const 8
    i32.mul
    local.tee $bag_start
    i32.const 0
    local.get $capacity
    i32.const 4
    i32.add
    local.tee $bag_end
    i32.const 4
    i32.add
    memory.fill
    local.get $bag_start
    local.get $bag_end
    i32.add
    local.set $bag_end

    (loop $outer_loop
      local.get $item_pointer
      i32.load
      i32.const 4
      i32.mul
      local.set $item_weight
      local.get $item_pointer
      i32.const 4
      i32.add
      i32.load
      local.set $item_value

      local.get $bag_end
      local.get $item_weight
      i32.sub
      local.tee $bag_pointer
      local.get $bag_start
      i32.ge_s
      (if (then (loop $inner_loop
        local.get $bag_pointer
        i32.load
        local.get $item_value
        i32.add
        local.tee $t
        local.get $bag_pointer
        local.get $item_weight
        i32.add
        local.tee $u
        i32.load
        i32.gt_s
        (if (then
          local.get $u
          local.get $t
          i32.store
          local.get $t
          local.get $r
          i32.gt_s
          (if (then
            local.get $t
            local.set $r
          ))
        ))
  
        local.get $bag_pointer
        i32.const 4
        i32.sub
        local.tee $bag_pointer
        local.get $bag_start
        i32.ge_s
        br_if $inner_loop
      )))

      local.get $item_pointer
      i32.const 8
      i32.add
      local.tee $item_pointer
      local.get $bag_start
      i32.lt_s
      br_if $outer_loop
    )

    local.get $r
    return
  )
)