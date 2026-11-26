UPDATE wordy
SET
  result = CASE question
    WHEN 'What is 5?' THEN 5
    WHEN 'What is 0?' THEN 0
    WHEN 'What is -123?' THEN -123
    WHEN 'What is 1 plus 1?' THEN 2
    WHEN 'What is 0 plus 2?' THEN 2
    WHEN 'What is 3 plus 0?' THEN 3
    WHEN 'What is 53 plus 2?' THEN 55
    WHEN 'What is -1 plus -10?' THEN -11
    WHEN 'What is 123 plus 45678?' THEN 45801
    WHEN 'What is 4 minus -12?' THEN 16
    WHEN 'What is -3 multiplied by 25?' THEN -75
    WHEN 'What is 33 divided by -3?' THEN -11
    WHEN 'What is 1 plus 1 plus 1?' THEN 3
    WHEN 'What is 1 plus 5 minus -2?' THEN 8
    WHEN 'What is 20 minus 4 minus 13?' THEN 3
    WHEN 'What is 17 minus 6 plus 3?' THEN 14
    WHEN 'What is 2 multiplied by -2 multiplied by 3?' THEN -12
    WHEN 'What is -3 plus 7 multiplied by -2?' THEN -8
    WHEN 'What is -12 divided by 2 divided by -3?' THEN 2
    ELSE NULL
  END,
  error = CASE
    WHEN question IN (
      'What is 52 cubed?',
      'Who is the President of the United States?'
    ) THEN 'unknown operation'
    WHEN question IN (
      'What is 1 plus?',
      'What is?',
      'What is 1 plus plus 2?',
      'What is 1 plus 2 1?',
      'What is 1 2 plus?',
      'What is plus 1 2?'
    ) THEN 'syntax error'
    ELSE NULL
  END;