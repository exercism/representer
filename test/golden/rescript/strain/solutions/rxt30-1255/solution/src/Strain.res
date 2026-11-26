let rec keep = (el, fn) => {
  let converted = List.fromArray(el)
  switch converted {
  | list{} => []
  | list{head, ...tail} =>
    if fn(head) {
      [head, ...keep(List.toArray(tail), fn)]
    } else {
      keep(List.toArray(tail), fn)
    }
  }
}
let rec discard = (el, fn) => {
  let converted = List.fromArray(el)
  switch converted {
  | list{} => []
  | list{head, ...tail} =>
    if fn(head) {
      discard(List.toArray(tail), fn)
    } else {
      [head, ...discard(List.toArray(tail), fn)]
    }
  }
}
