RotationalCipher :: {}.{
	rotate : Str, U8 -> Str
	rotate = |text, shift_key|
		text
        .to_utf8()
        .map(|c| rotate_char(c, shift_key))
        |> Str.from_utf8_lossy()
}

rotate_char : U8, U8 -> U8
rotate_char = |char, shift_key| {
    r = |a| (char + a + shift_key) % 26 + a

    if char >= 'A' and char <= 'Z'
        r('A')
    else if char >= 'a' and char <= 'z'
        r('a')
    else
        char
}