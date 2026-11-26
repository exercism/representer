
(module
  ;; Globals to track account state and balance
  (global $is_open (mut i32) (i32.const 0))     ;; 0 = closed, 1 = open
  (global $balance (mut i32) (i32.const 0))     ;; initial balance

  ;; Open the account
  ;; Returns 0 on success, -1 if already open
  (func (export "open") (result i32)
    (if (i32.eq (global.get $is_open) (i32.const 1))
      (then (return (i32.const -1)))
    )
    (global.set $is_open (i32.const 1))
    (global.set $balance (i32.const 0))
    (return (i32.const 0))
  )

  ;; Close the account
  ;; Returns 0 on success, -1 if already closed
  (func (export "close") (result i32)
    (if (i32.eq (global.get $is_open) (i32.const 0))
      (then (return (i32.const -1)))
    )
    (global.set $is_open (i32.const 0))
    (return (i32.const 0))
  )

  ;; Deposit money
  ;; @param {i32} amount
  ;; @return {i32} 0 on success, -1 if closed, -2 if negative
  (func (export "deposit") (param $amount i32) (result i32)
    (if (i32.eq (global.get $is_open) (i32.const 0))
      (then (return (i32.const -1)))
    )
    (if (i32.lt_s (local.get $amount) (i32.const 0))
      (then (return (i32.const -2)))
    )
    (global.set $balance
      (i32.add (global.get $balance) (local.get $amount))
    )
    (return (i32.const 0))
  )

  ;; Withdraw money
  ;; @param {i32} amount
  ;; @return {i32} 0 on success, -1 if closed, -2 if invalid
  (func (export "withdraw") (param $amount i32) (result i32)
    (if (i32.eq (global.get $is_open) (i32.const 0))
      (then (return (i32.const -1)))
    )
    (if (i32.or
          (i32.lt_s (local.get $amount) (i32.const 0))
          (i32.gt_s (local.get $amount) (global.get $balance))
        )
      (then (return (i32.const -2)))
    )
    (global.set $balance
      (i32.sub (global.get $balance) (local.get $amount))
    )
    (return (i32.const 0))
  )

  ;; Get current balance
  ;; @return {i32} balance or -1 if closed
  (func (export "balance") (result i32)
    (if (i32.ne (global.get $is_open) (i32.const 0))
      (then (return (i32.const -1)))
    )
    (return (global.get $balance))
  )
)



