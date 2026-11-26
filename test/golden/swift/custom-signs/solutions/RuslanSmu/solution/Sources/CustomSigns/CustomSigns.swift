// TODO: define the 'birthday' String constant
let birthday = "Birthday"

// TODO: define the 'valentine' String constant
let valentine = "Valentine's Day"

// TODO: define the 'anniversary' String constant
let anniversary = "Anniversary"

// TODO: define the 'space' Character constant
let space: Character = " "

// TODO: define the 'exclamation' Character constant
let exclamation: Character = "!"

func buildSign(for occasion: String, name: String) -> String {
    let k = "Happy" + String(space) + occasion + String(space) + name + String(exclamation)
    return k
  //fatalError("Please implement the buildSign(for:name:) function")
}

func graduationFor(name: String, year: Int) -> String {
    return "Congratulations \(name)!\nClass of \(year)"
  //fatalError("Please implement the graduationFor(name:year:) function")
}

func costOf(sign: String) -> Int {
    return (sign.count * 2) + 20
  //fatalError("Please implement the costOf(sign:) function")
}

