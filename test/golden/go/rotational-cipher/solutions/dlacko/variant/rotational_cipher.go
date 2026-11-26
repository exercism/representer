package rotationalcipher

import "unicode"

// RotationalCipher implementats the Caesar cipher.
func RotationalCipher(plainText string, key int) string {
	cipherText := []rune(plainText)
	for i := range cipherText {
		if unicode.IsLetter(cipherText[i]) {
			a := int('a')
			if unicode.IsUpper(cipherText[i]) {
				a = 'A'
			}
			cipherText[i] = rune((int(cipherText[i])+a+key)%26 + a)
		}
	}
	return string(cipherText)
}