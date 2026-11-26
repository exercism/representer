module TwoFer

export
twoFer : Maybe String -> String
twoFer Nothing =  "One for you, one for me."
twoFer (Just x) =  "One for \{x}, one for me."
