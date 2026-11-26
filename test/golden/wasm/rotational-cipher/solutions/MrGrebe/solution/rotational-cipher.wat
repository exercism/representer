(module
  (import "console" "log_i32_u" (func $log_i32_u (param i32)))
  (import "console" "log_mem_as_utf8" (func $log_mem_as_utf8 (param $byteOffset i32) (param $length i32)))
  (memory (export "mem") 1)

  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)

   (local $ascii i32)
   (local $c i32) 
   (local $i i32)

        
   (block $myblock
     
   (loop $myloop
     
     (i32.eq (local.get $i) (local.get $textLength))

     (if (then (br $myblock)))

     (local.set $ascii (i32.load8_u (i32.add (local.get $textOffset) (local.get $i))))

     

     (i32.and (i32.ge_u (local.get $ascii) (i32.const 65)) (i32.le_u (local.get $ascii) (i32.const 90)))

     (if 
      (then

       (local.set $c (i32.add (local.get $ascii) (i32.const -65)))
        
       

  
        
       (i32.store8  (i32.add (local.get $textOffset) (local.get $i))
         (i32.add (i32.rem_u (i32.add (local.get $c) (local.get $shiftKey)) (i32.const 26)) (i32.const 65))
        )

          
       )
      (else 
        
          (i32.and (i32.ge_u (local.get $ascii) (i32.const 97)) (i32.le_u (local.get $ascii) (i32.const 122)))
         (if 
      (then
              
       (local.set $c (i32.add (local.get $ascii) (i32.const -97)))

                
       

        

       
              
       (i32.store8  (i32.add (local.get $textOffset) (local.get $i))
         (i32.add (i32.rem_u (i32.add (local.get $c) (local.get $shiftKey)) (i32.const 26)) (i32.const 97))
        )

        
        
       ))))

     (local.set $i (i32.add (local.get $i) (i32.const 1)))
     (br $myloop)
    )
    )
   
    
    (return (local.get $textOffset) (local.get $textLength))
  )
)
