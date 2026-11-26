#include "list_ops.h"
#include <stdlib.h>

// constructs a new list
list_t *new_list(size_t length, list_element_t elements[]) {
  list_t *list = malloc(sizeof(list_t) + length * sizeof(list_element_t));
  list->length = length;
  memcpy(&list->elements, elements, length * sizeof(list_element_t));
  return list;
}

// append entries to a list and return the new list
list_t *append_list(list_t *list1, list_t *list2) {
  size_t length = list1->length + list2->length;
  list_t *list = malloc(sizeof(list_t) + length * sizeof(list_element_t));
  list->length = length;
  memcpy(list->elements, list1->elements,
         list1->length * sizeof(list_element_t));
  memcpy(&list->elements[list1->length], list2->elements,
         list2->length * sizeof(list_element_t));
  return list;
}

// // filter list returning only values that satisfy the filter function
list_t *filter_list(list_t *list, bool (*filter)(list_element_t)) {
  list_t *result;
  size_t length = 0;
  list_element_t *elements = malloc(list->length * sizeof(list_element_t));
  for (size_t i = 0; i < list->length; i++) {
    if (filter(list->elements[i])) {
      elements[length++] = list->elements[i];
    }
  }
  result = new_list(length, elements);
  free(elements);
  return result;
}

// returns the length of the list
size_t length_list(list_t *list) { return list->length; }

// return a list of elements whose values equal the list value transformed by
// the mapping function
list_t *map_list(list_t *list, list_element_t (*map)(list_element_t)) {
  list_t *result =
      malloc(sizeof(list_t) + list->length * sizeof(list_element_t));
  result->length = list->length;
  for (size_t i = 0; i < list->length; i++) {
    result->elements[i] = map(list->elements[i]);
  }
  return result;
}

// folds (reduces) the given list from the left with a function
list_element_t foldl_list(list_t *list, list_element_t initial,
                          list_element_t (*foldl)(list_element_t,
                                                  list_element_t)) {
  for (size_t i = 0; i < list->length; i++) {
    initial = foldl(initial, list->elements[i]);
  }
  return initial;
}

// folds (reduces) the given list from the right with a function
list_element_t foldr_list(list_t *list, list_element_t initial,
                          list_element_t (*foldr)(list_element_t,
                                                  list_element_t)) {
  for (size_t i = list->length; i--;) {
    initial = foldr(list->elements[i], initial);
  }
  return initial;
}

// reverse the elements of the list
list_t *reverse_list(list_t *list) {
  list_t *result =
      malloc(sizeof(list_t) + list->length * sizeof(list_element_t));
  result->length = list->length;
  for (size_t i = 0; i < list->length; i++) {
    result->elements[list->length - i - 1] = list->elements[i];
  }
  return result;
}

// destroy the entire list
// list will be a dangling pointer after calling this method on it
void delete_list(list_t *list) { free(list); }
