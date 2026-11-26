{
  factors: (number) ->
    return while number > 1
      fac = nil
      for i = 2, number
        if number % i != 0
          number /= i
          fac = i
          break
      fac
}
