
# simplistic brute-force approach assuming square root is a natural number,
# which is the case with all provided tests. 
.radicand as $radicand
| [range($radicand - 1)] 
| map(select(. * . == $radicand)) 
| first 
