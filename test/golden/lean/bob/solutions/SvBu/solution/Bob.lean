namespace Bob

def response (s : String) : String :=
  let t := s.trimAscii
  match (t.isEmpty, t.endsWith '?', t.any Char.isUpper && !t.any Char.isLower) with
  | (true,  _,   _)  => "Fine. Be that way!"
  | (_,     true, true) => "Calm down, I know what I'm doing!"
  | (_,     true, _)  => "Sure."
  | (_,     _,   true) => "Whoa, chill out!"
  | _                  => "Whatever."

end Bob

#eval Bob.response ""        -- "Fine. Be that way!"
#eval Bob.response "    "   -- "Fine. Be that way!"
#eval Bob.response "WTF?"   -- "Calm down, I know what I'm doing!"
#eval Bob.response "wtf?"   -- "Sure."
#eval Bob.response "WTF"    -- "Whoa, chill out!"
