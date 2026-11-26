
let birthday:String = "Birthday"
let valentine:String = "Valentine's Day"
let anniversary:String = "Anniversary"
let space:Character = " "
let exclamation:Character = "!"

func buildSign(for: String, name: String) -> String {
    return "Happy \(`for`) \(name)\(exclamation)"
}

func graduationFor(name: String, year: Int) -> String {
    return "Congratulations \(name)!\nClass of \(year)"
}

func costOf(sign: String) -> Int {
    return 2*sign.count+20
}
