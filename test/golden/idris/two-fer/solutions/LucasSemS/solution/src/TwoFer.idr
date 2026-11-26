module TwoFer

public export
twoFer : Maybe String -> String
twoFer (Just name) = "One for " ++ name ++ ", one for me."
twoFer Nothing     = "One for you, one for me."
