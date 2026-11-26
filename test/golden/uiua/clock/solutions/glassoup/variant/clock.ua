┌─╴Clock
  # Create a new clock
  # Clock ? Hours Minutes
  New ← ◿₁₄₄₀+×₆₀

  # Add minutes to a clock
  # Clock ? Minutes Clock
  Add ← ◿₁₄₄₀+

  # Subtract minutes to a clock
  # Clock ? Minutes Clock
  Sub ← ◿₁₄₄₀-

  # Return a clock's time formatted as a string
  # String ? Clock
  Display ← $"_:_"∩(⍥(⊂@1)=₁⊸⧻°⋕)⌊⊃÷₆₀◿₆₀
└─╴