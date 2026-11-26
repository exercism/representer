sum = (list) ->
  res = 0
  for n in *list do res += n
  res

factors = (n) -> [m for m = 1, n - 1 when n % m == 0]

{
  classify: (number) ->
    error 'Classification is only possible for positive integers.' if number < 1
    aliquot = sum factors number
    if aliquot < number then 'deficient'
    elseif aliquot > number then 'abundant'
    else 'perfect'
}
