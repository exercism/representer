function keep(list, cb) {
  let keep = [];
  for (let item of list) {
    if (cb(item)) keep.unshift(item);
  }
  return keep;
}

function discard(list, cb) {
  let discard = [];
  for (let item of list) {
    if (!cb(item)) discard.push(item);
  }
  return discard;
}

exports.keep = keep;
exports.discard = discard;