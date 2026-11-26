# Calculate someone's space age
Ratios   ← [0.2408467 0.61519726 1.0 1.8808158 11.862615 29.447498 84.016846 164.79132]
Names    ← {"Mercury" "Venus" "Earth" "Mars" "Jupiter" "Saturn" "Uranus" "Neptune"}
# Age ? Planet Seconds
SpaceAge ← |2 ⨬(÷100 ⁅×100 ÷31557601 ÷ ˜⊡ Ratios ⊢⊚|"not a planet") ⊸(=0/+) ˜⌕ Names □ 

