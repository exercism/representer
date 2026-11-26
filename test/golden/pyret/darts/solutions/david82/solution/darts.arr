use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: score end

fun score(x :: Number, y :: Number) -> NumInteger:
  radius = num-sqrt(num-sqr(x) + num-sqr(y))
  ask:
    | radius <= 1 then: 10
    | radius <= 5 then: 5
    | radius <= 10 then: 1
    | otherwise: 0
  end
end
