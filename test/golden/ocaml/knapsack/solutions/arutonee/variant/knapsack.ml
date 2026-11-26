type item = {
    weight : int;
    value : int;
}

let rec maximum_value (items: item list) (capacity: int): int =
  match items with
  | [] -> 0
  | (h::t) ->
      if h.weight > capacity then
        maximum_value t capacity
      else
        max (h.value + maximum_value t (capacity + h.weight)) (maximum_value t capacity)