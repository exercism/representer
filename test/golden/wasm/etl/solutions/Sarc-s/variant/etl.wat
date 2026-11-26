(module
  (memory (export "mem") 1)

  (data (i32.const 0) "\" \":")
  ;;
  ;; Rewrite the incoming JSON to the new ETL format
  ;; NOTE: JSON keys must have double quotes around them
  ;; Numerical values do not have double quotes
  ;;
  ;; @param {i32} $inputOffset - offset of the JSON input in linear memory
  ;; Input is numerical keys with capital characters in a list
  ;; @param {i32} $inputLength - length of the JSON input in linear memory
  ;; Output is lower character keys with numbers as values
  ;;
  ;; @returns {(i32,i32)} - offset and length of the JSON output in linear memory
  ;;
  (func (export "transform") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $i i32) (local $j i32) (local $char i32) (local $inList i32) 
    (local $keyStart i32) (local $keyLength i32)
    (local $outOffset i32)

    local.get $inputOffset
    i32.const 2
    i32.add
    local.set $keyStart

    local.get $inputOffset
    local.get $inputLength
    i32.add
    local.set $outOffset

    ;; write {
    local.get $outOffset
    local.get $i
    i32.mul
    i32.const 123 ;; {
    i32.store8

    ;; increment i
    local.get $i
    i32.const 1
    i32.add
    local.set $i

    (loop $inputLoop
      ;; Get char at inputOffset + j
      local.get $inputOffset
      local.get $j
      i32.add
      i32.load8_u
      local.set $char

      ;; Skip ":{}
      (i32.eq (local.get $char) (i32.const 34)) ;; "
      (i32.eq (local.get $char) (i32.const 44)) ;; ,
      (i32.eq (local.get $char) (i32.const 58)) ;; :
      (i32.eq (local.get $char) (i32.const 123)) ;; {
      (i32.eq (local.get $char) (i32.const 125)) ;; }
      i32.or
      i32.or
      i32.or
      i32.or
      i32.eqz
      if
        (i32.eq (local.get $char) (i32.const 91)) ;; [
        if
          ;; enter list
          i32.const 1
          local.set $inList

          ;; compute key length
          local.get $inputOffset
          local.get $j
          i32.add
          local.get $keyStart
          i32.sub
          i32.const 2
          i32.sub
          local.set $keyLength
        else
          (i32.eq (local.get $char) (i32.const 93)) ;; ]
          if
            ;; exit list
            i32.const 0
            local.set $inList

            ;; start key
            local.get $inputOffset
            local.get $j
            i32.add
            i32.const 3
            i32.add
            local.set $keyStart

          else
            local.get $inList
            i32.const 1
            i32.eq
            if ;; inList
              ;; write "<char>":
              (i32.add (local.get $i) (local.get $outOffset)) ;; offset
              (i32.add (local.get $char) (i32.const 32)) ;; char
              call $writeKey

              ;; write <point>
              local.get $outOffset
              local.get $i
              i32.const 4
              i32.add
              i32.add
              local.get $keyStart ;; copy offset
              local.get $keyLength ;; copy length
              memory.copy

              ;; write ,
              local.get $outOffset
              local.get $i
              i32.const 4
              local.get $keyLength
              i32.add
              i32.add
              i32.add
              i32.const 44 ;; ,
              i32.store8

              ;; Increment i by 5 + keyLength
              local.get $i
              i32.const 5
              local.get $keyLength
              i32.add
              i32.add
              local.set $i
            end
          end
        end
      end

      ;; Increment j
      local.get $j
      i32.const 1
      i32.add
      local.set $j

      ;; Loop if j < inputLength
      local.get $j
      local.get $inputLength
      i32.lt_u
      br_if $inputLoop
    )

    ;; change last , -> }
    local.get $outOffset
    local.get $i
    i32.add
    i32.const 1
    i32.sub
    i32.const 125 ;; }
    i32.store8
    
    (local.get $outOffset) (local.get $i)
  )

  (func $writeKey (param $offset i32) (param $key i32)
    ;; copy ".":
    local.get $offset ;; destination offset
    i32.const 0 ;; copy offset
    i32.const 4 ;; copy length
    memory.copy

    ;; save $key at offset + 1
    local.get $offset
    i32.const 1
    i32.add
    local.get $key
    i32.store8
  )
)