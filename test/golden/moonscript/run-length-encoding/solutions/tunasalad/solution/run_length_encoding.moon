{
  encode: (plaintext) ->
    pn = plaintext\len!
    i = 1
    res = {}
    while i <= pn
      c = plaintext\sub i, i
      j = i + 1
      while j <= pn and c == plaintext\sub j, j
        j += 1
      t = if j - i == 1 then c else tonumber(j - i) .. c
      table.insert res, t
      i = j
    table.concat res

  decode: (ciphertext) ->
    res = for ch in ciphertext\gmatch "%d*[^%d]"
      n = ch\len!
      if n == 1
        ch
      else
        ch\sub(n)\rep tonumber ch\sub(1, n - 1)
          
    table.concat res
}
