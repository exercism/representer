{
  hey: (s) ->
    s = s\gsub "[ \n\r\t]", ""
    return "Fine. Be that way!" if s == ""

    is_q = s\sub(s\len!) == "?"
    is_up = s\lower! != s and s\upper! == s
    if is_q
      if is_up
        "Calm down, I know what I'm doing!"
      else
        "Sure."
    else
      if is_up
        "Whoa, chill out!"
      else
        "Whatever."
}
