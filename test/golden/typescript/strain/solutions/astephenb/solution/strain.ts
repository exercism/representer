export function keep<T>(arr: T[], pred: (elem: T) => boolean): T[] {
  return arr.filter(pred)
}

export function discard<T>(arr: T[], pred: (elem: T) => boolean): T[] {
  return arr.filter((elem) => !pred(elem))
}
