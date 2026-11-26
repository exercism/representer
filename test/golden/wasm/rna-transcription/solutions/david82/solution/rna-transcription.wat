(module
  ;; Export a memory of 1 page (64KiB)
  (memory (export "mem") 1)

  ;;
  ;; Convert a string of DNA to RNA
  ;;
  ;; @param {i32} offset - The offset of the DNA string in linear memory
  ;; @param {i32} length - The length of the DNA string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the RNA string in linear memory
  ;;
  (func (export "toRna") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32) ;; Local variable for loop index
    (loop $l ;; Loop label
      ;; Store the converted nucleotide (DNA to RNA) back into memory
      (i32.store8 
        (i32.add (local.get $offset) (local.get $i)) ;; Calculate address of the current nucleotide
        (call $dna2rna ;; Call the conversion function
          (i32.load8_u (i32.add (local.get $offset) (local.get $i))) ;; Load the current nucleotide
        )
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1))) ;; Increment the loop index
      (br_if $l (i32.lt_u (local.get $i) (local.get $length))) ;; Continue loop if not at the end of the string
    )
    (return (local.get $offset) (local.get $length)) ;; Return the offset and length of the RNA string
  )

  ;; Helper function to convert a single DNA nucleotide to its RNA complement
  ;; @param {i32} value - ASCII value of the DNA nucleotide
  ;; @returns {i32} - ASCII value of the corresponding RNA nucleotide
  (func $dna2rna (param $value i32) (result i32)
    ;; If the nucleotide is 'G' (0x47), return 'C' (0x43)
    (if (i32.eq (local.get $value) (i32.const 0x47)) (then (return (i32.const 0x43))))
    ;; If the nucleotide is 'C' (0x43), return 'G' (0x47)
    (if (i32.eq (local.get $value) (i32.const 0x43)) (then (return (i32.const 0x47))))
    ;; If the nucleotide is 'T' (0x54), return 'A' (0x41)
    (if (i32.eq (local.get $value) (i32.const 0x54)) (then (return (i32.const 0x41))))
    ;; If the nucleotide is 'A' (0x41), return 'U' (0x55)
    (if (i32.eq (local.get $value) (i32.const 0x41)) (then (return (i32.const 0x55))))
    ;; Default case (should not be reached with valid DNA input)
    (i32.const 0)
  )
)
