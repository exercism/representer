// TODO: define the 'birthday' String constant
let birthday = "Birthday"
// TODO: define the 'valentine' String constant
let valentine = "Valentine's Day"
// TODO: define the 'anniversary' String constant
let anniversary = "Anniversary"
// TODO: define the 'space' Character constant
let space:Character = .init(" ")
// TODO: define the 'exclamation' Character constant
let exclamation:Character = .init("!")
func buildSign(for occasion: String, name: String) -> String {
    "Happy"+space.description+occasion+space.description+name+exclamation.description
}

func graduationFor(name: String, year: Int) -> String {
    "Congratulations"+space.description+name+exclamation.description+"\nClass"+space.description+"of"+space.description+"\(year)"
}

func costOf(sign: String) -> Int {
    sign.count * 2  + 20
}
