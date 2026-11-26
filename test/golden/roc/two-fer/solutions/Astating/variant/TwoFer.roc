TwoFer :: {}.{
	two_fer : [Name(Str), Anonymous] -> Str
	two_fer = |name| {
		them = match name {
            Name(n) => n
            Anonymous => "ypu"
        }

        "One for ${them}, one for me."
	}
}
