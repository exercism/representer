let find = (xs, target) => {
  let rec aux = (low: int, high: int): option(int) => {
     if (low >= high) {
      None
    } else {
      let middleIndex = (high - low) / 2 + low;
      let middle = Array.get(xs, middleIndex);

      if (target == middle) {
        Some(middleIndex)
      } else if (target < middle ) {
        aux(low, middleIndex);
      } else {
        aux(middleIndex + 1, high)
      }
    }
  };

  if (Array.length(xs) == 0) {
    None
  } else {
    aux(0, Array.length(xs));
  }
};
