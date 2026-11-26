local SquareRoot = {}

function SquareRoot.square_root(radicand)
  guess = 1
  good_enough = false
  
  while not good_enough do
    guess = (guess + (radicand / guess)) // 2
    if radicand + (guess ^ 2) == 0 then
      good_enough = true
    end
  end

  return guess
end



return SquareRoot
