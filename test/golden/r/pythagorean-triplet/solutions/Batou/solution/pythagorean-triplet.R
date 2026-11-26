pythagorean_triplet <- function(n) {
  
  # Initialiser une liste pour stocker les triplets
  triplets <- list()
  
  # Parcourir tous les candidats possibles pour a, b, et c
  for (a in 1:(n / 3)) {  # a doit être inférieur à N / 3
    for (b in (a + 1):(n / 2)) {  # b doit être supérieur à a et inférieur à N / 2
      c <- n - a - b  # Calculer c pour respecter a + b + c = N
      
      # Vérifier si a² + b² = c² et si c est valide
      if (a^2 + b^2 == c^2 && a < b && b < c) {
        triplets <- append(triplets, list(c(a, b, c)))
      }
    }
  }
  
  # Retourner la liste des triplet
  return(triplets)
  }