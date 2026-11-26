package isogram

is_isogram :: proc(word: string) -> bool {
	seen: u32 = 0
	
	for b in transmute([]u8)word {
		lower := b | 0x20
		
		if lower >= 'a' && lower <= 'z' {
			bit_pos := u32(lower - 'a')
			
			if seen & (1 << bit_pos) != 0 {
				return false
			}
			
			seen |= (1 << bit_pos)
		}
		// Non-letter characters (spaces, hyphens) are ignored
	}
	
	return true
}
        