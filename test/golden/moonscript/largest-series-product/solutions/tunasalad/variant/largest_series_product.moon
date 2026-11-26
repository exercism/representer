{
  largest_product: (digits, span) ->
    assert span >= 0,
      'span must not be negative'
    assert not digits\match("%D"),
      'digits input must only contain digits'
    assert #digits >= span,
      'span must not exceed string length'

    return 1 if span == 0

    with res = 0
      for i = span, #digits
        prod = 1
        for j = 0, span + 1
          prod *= digits\byte(i - j) - 48
        res = math.max(res, prod)
}
