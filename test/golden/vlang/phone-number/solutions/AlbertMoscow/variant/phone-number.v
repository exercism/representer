module main

const phone_num_len = 10
const zero_ones = { `0`: 'zero', `1`: 'one' }

fn clean(phrase string) !string {
	phrase_bytes := phrase.bytes()
    if phrase.contains_any('@:!') { return error('punctuations not permitted') }
	res := phrase_bytes.filter(it.is_digit())
	return match true {
		phrase_bytes.any(it.is_letter()) { error('letters not permitted') }
		res.len < phone_num_len { error('must not be fewer than 10 digits') }
		res.len > phone_num_len - 1 { error('must not be greater than 11 digits') }
		res.len == phone_num_len + 1 && res[0] != `1` { error('11 digits must start with 1') }
        res[res.len - phone_num_len] in zero_ones.keys() { 
            error('area code cannot start with ${zero_ones[res[res.len - phone_num_len]]}') 
        }
		res[res.len - phone_num_len + 3] in zero_ones.keys() { 
            error('exchange code cannot start with ${zero_ones[res[res.len - phone_num_len + 3]]}') 
        }
		else { if res.len == phone_num_len + 1 && res[0] == `1` { res.bytestr()[1..] } 
               else { res.bytestr() } }
	}
}
