allergy <- function(num) {
  allergies <- c("eggs",     "peanuts",   "shellfish", "strawberries",
                 "tomatoes", "chocolate", "pollen",    "cats")
  bits <- intToBits(num)[1:length(allergies)]
  me <- allergies[bits != 0]
  class(me) <- append(class(me), "allergy")
  me
}

allergic_to <- function(allergy_object, allergy) {
  allergy %in% allergy_object
}

list_allergies <- function(allergy_object) {
  as.character(allergy_object)
}