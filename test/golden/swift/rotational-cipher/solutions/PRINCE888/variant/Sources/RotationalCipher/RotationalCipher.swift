func rotateCipher(_ input: String, shift: Int) -> String {
    var result = ""
    var newShift = UInt8(shift)
    for char in input {
        guard char.isLetter else { result.append(char); continue }
        let newChar = Character(char.uppercased()).asciiValue! + newShift >= 90 ? Unicode.Scalar(Character(char.uppercased()).asciiValue! + newShift - 26) : Unicode.Scalar(Character(char.uppercased()).asciiValue! + newShift)
        result += char.isUppercase ? String(newChar) : String(newChar).lowercased()
    }
    return result
}