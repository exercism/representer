func commands(number: Int) -> [String] {
    let commandOptions = HandshakeOption(rawValue: number)
    
    let commandStrings = HandshakeOption.allHandshakeOptions
        .compactMap { (option, name) in
            return commandOptions.contains(option) ? name : nil
        }
    
    return commandOptions.contains(.reverseOrder) ? commandStrings.reversed() : commandStrings
}

fileprivate struct HandshakeOption: OptionSet {
    let rawValue: Int
    
    static let wink         = HandshakeOption(rawValue: 1 << 0)
    static let doubleBlink  = HandshakeOption(rawValue: 1 << 1)
    static let closeEyes    = HandshakeOption(rawValue: 1 << 2)
    static let jump         = HandshakeOption(rawValue: 1 << 3)
    static let reverseOrder = HandshakeOption(rawValue: 1 << 4)
    
    static let allHandshakeOptions: [(HandshakeOption, String)] = [
        (.wink, "wink"),
        (.doubleBlink, "double blink"),
        (.closeEyes, "close your eyes"), 
        (.jump, "jump"),
        // Do not include reverseOrder as it's not a handshake, but rather an ordering command. It's handled separately.
    ]
}
