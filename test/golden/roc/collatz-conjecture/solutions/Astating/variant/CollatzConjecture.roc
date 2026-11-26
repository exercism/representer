CollatzConjecture :: {}.{
  steps : U64 -> Try(U64, _)
  steps = |number| match number {
    0 => Err(StartingNumberHasToBePositive)

    _ => Ok(
      count_collatz_steps(
        number,
        {counter: 0}
      )
    )
  } 
}

count_collatz_steps = |number, {counter}| match number {
  1 => counter
    
  _ => count_collatz_steps(
    if (number.is_even()) number / 2
    else number / 3 + 1,
    {counter: counter + 1}
  )
}
