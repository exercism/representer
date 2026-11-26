(module
  (func (export "eggCount") (param $number i32) (result i32)
    (local.get $number)
    (return (i32.popcnt))
  )
)
