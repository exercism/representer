(module
  (memory (export "mem") 1)

  (func (export "maximumValue") (param $itemsCount i32) (param $capacity i32) (result i32)
    (local $i i32)         ;; Item index
    (local $j i32)         ;; Capacity
    (local $w i32)         ;; Item weight
    (local $v i32)         ;; Item value
    (local $dp_base i32)   ;; DP array base offset
    (local $item_addr i32) ;; Item base offset
    (local $old i32)       ;; Old DP[j]
    (local $cand i32)      ;; Candidate value

    ;; DP base = itemsCount * 8
    local.get $itemsCount
    i32.const 8
    i32.mul
    local.set $dp_base

    ;; Zero DP array [0..capacity]
    local.get $dp_base
    local.set $j
    (block $done
      (loop $zero
        local.get $j
        local.get $dp_base
        local.get $capacity
        i32.const 1
        i32.add
        i32.const 4
        i32.mul
        i32.add
        i32.ge_u
        br_if $done
        local.get $j
        i32.const 0
        i32.store
        local.get $j
        i32.const 4
        i32.add
        local.set $j
        br $zero
      )
    )

    ;; For each item
    i32.const 0
    local.set $i
    (block $break_items
      (loop $items
        local.get $i
        local.get $itemsCount
        i32.ge_u
        br_if $break_items

        ;; item_addr = i * 8
        local.get $i
        i32.const 8
        i32.mul
        local.set $item_addr

        ;; w = item_addr[0]
        local.get $item_addr
        i32.load
        local.set $w

        ;; v = item_addr[4]
        local.get $item_addr
        i32.const 4
        i32.add
        i32.load
        local.set $v

        ;; for j = capacity .. w (down)
        local.get $capacity
        local.set $j
        (block $break_j
          (loop $cap
            local.get $j
            local.get $w
            i32.lt_u
            br_if $break_j

            ;; old = dp[j]
            local.get $dp_base
            local.get $j
            i32.const 4
            i32.mul
            i32.add
            i32.load
            local.set $old

            ;; cand = dp[j - w] + v
            local.get $dp_base
            local.get $j
            local.get $w
            i32.sub
            i32.const 4
            i32.mul
            i32.add
            i32.load
            local.get $v
            i32.add
            local.set $cand

            ;; if cand > old, dp[j] = cand
            local.get $cand
            local.get $old
            i32.gt_s
            if
              local.get $dp_base
              local.get $j
              i32.const 4
              i32.mul
              i32.add
              local.get $cand
              i32.store
            end

            ;; j--
            local.get $j
            i32.const 1
            i32.sub
            local.set $j
            br $cap
          )
        )

        ;; i++
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $items
      )
    )

    ;; return dp[capacity]
    local.get $dp_base
    local.get $capacity
    i32.const 4
    i32.mul
    i32.add
    i32.load
  )
)