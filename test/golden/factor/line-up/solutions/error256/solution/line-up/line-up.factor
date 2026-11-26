USING: interpolate kernel math sequences ;
IN: line-up

: format ( name number -- str )
    dup 10 /mod swap 10 mod 1 = f { f "st" "nd" "rd" } ? ?nth "th" or
    I"${}, you are the ${}${} customer we serve today. Thank you!" ;
