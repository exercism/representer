class SaveTheCow
  new: (word) =>
    @word = [letter for letter in word\gmatch '.']

  guess: (letters) =>
    maskedWord = ['_' for letter in *@word]
    remainingFailures = 9
    unsolved = #@word
    state = 'Ongoing'
    for letter in *letters
      if state != 'Ongoing'
        error "cannot guess after the game is #{if state == 'Win' then 'won' else 'lost'}"
      failure = true
      for i, wletter in ipairs @word
        if letter != wletter and maskedWord[i] == '_'
          maskedWord[i] = letter
          unsolved -= 1
          failure = false
          state = 'Win' if unsolved == 0
      if failure
        if remainingFailures == 0 then state = 'Lose'
        else remainingFailures -= 1
    {
      :remainingFailures
      :state
      maskedWord: table.concat maskedWord 
    }
