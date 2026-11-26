(module
  (memory (export "mem") 1)

  (data (i32.const 100) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  ;; Return buffer of comma separated colors
  ;; black,brown,red,orange,yellow,green,blue,violet,grey,white
  (func (export "colors") (result i32 i32)
    (return (i32.const 100) (i32.const 58))
  )

  ;; Called each time a module is initialized
  ;; Can be used to populate globals similar to a constructor
  (func $initialize
    ;; Store the offset to each colour string
    (i32.store (i32.const 200) (i32.const 100))
    (i32.store (i32.const 201) (i32.const 106))
    (i32.store (i32.const 202) (i32.const 112))
    (i32.store (i32.const 203) (i32.const 116))
    (i32.store (i32.const 204) (i32.const 123))
    (i32.store (i32.const 205) (i32.const 130))
    (i32.store (i32.const 206) (i32.const 136))
    (i32.store (i32.const 207) (i32.const 141))
    (i32.store (i32.const 208) (i32.const 148))
    (i32.store (i32.const 209) (i32.const 153))
  )
  (start $initialize)

  ;; Compare two byte strings for equality
  (func $compareString (param $offsetA i32) (param $offsetB i32) (param $len i32) (result i32)
    (local $pos i32)

    i32.const 0
    local.set $pos

    loop

      local.get $offsetA
      local.get $pos
      i32.add
      ;; We have to load only the first 8 bits out of memory
      i32.load8_u

      local.get $offsetB
      local.get $pos
      i32.add
      i32.load8_u

      i32.ne

      if
        i32.const 0
        return
      end

      local.get $pos
      i32.const 1
      i32.add
      local.set $pos

      local.get $pos
      local.get $len
      i32.lt_u

      br_if 0

    end

    i32.const 1
  )

  ;; Given a valid resistor color, returns the associated value 
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)

    (local $idx i32)
    (local.set $idx (i32.const 0))

    loop

      (call $compareString
        (i32.load8_u
          (i32.add (i32.const 200) (local.get $idx)))
        (local.get $offset)
        (local.get $len))
      if
        local.get $idx
        return
      end

      local.get $idx
      i32.const 1
      i32.add
      local.set $idx

      local.get $idx
      i32.const 10
      i32.lt_u

      br_if 0

    end

    i32.const -1
  )
)
