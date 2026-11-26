module TwoFer

export
twoFer : Maybe String -> String
twoFer Nothing = "One for you, one for me."
twoFer (Just name) = "One for \{name}, one for me."
