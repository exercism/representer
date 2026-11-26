allergy <- function(num) {
  SCORE_BY_ALLERGEN <- c(eggs=1, peanuts=2, shellfish=4, strawberries=8, tomatoes=16, chocolate=32, pollen=64, cats=128)
  checks <- bitwAnd(num,SCORE_BY_ALLERGEN)
  names(SCORE_BY_ALLERGEN)[which(checks > 0)]
}

allergic_to <- function(allergy_object, allergy) {
  allergy %in% allergy_object
}

list_allergies <- function(allergy_object) {
  allergy_object
}
