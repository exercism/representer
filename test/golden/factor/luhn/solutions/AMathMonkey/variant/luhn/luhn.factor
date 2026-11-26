USING: kernel math math.functions math.order math.parser sequences continuations combinators.smart ;
IN: luhn

:: valid? ( value -- ? )
    0 :> digits!
    [
      value reverse
      [| d |
        d digit>
        [ 255 = ]
        [ drop d CHAR: space = [ 0 ] [ "invalid char" throw ] if ]
        [
          digits even? [ 2 * [ 9 > ] [ 9 - ] 1when ] unless
          digits 1 + digits!
        ]
        smart-if
      ] map-sum
      10 divisor? digits 1 > or
    ]
    [ drop f ]
    recover ;
