module TwoFer

export
twoFer : Maybe String -> String
twoFer name = case name of 
    Nothing => "One for you, one for me."
    Just name => "One gor " ++ name ++ ", one for me."
