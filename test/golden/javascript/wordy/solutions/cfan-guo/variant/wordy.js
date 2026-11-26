//
// This is only a SKELETON file for the 'Wordy' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

const ops = {
  "plus" : "+",
  "minus": "-",
  "multiplied": "*",
  "divided": "/"
}

export const answer = (question) => {
  // assumed all legitimate questions start with "What is" and end with "?"
  if (question.match(/What is/)) {

    // if there are two consecutive numbers, immediately throw
    if (question.match(/\d+\s+\d+/) !== null) { throw new Error('Syntax error'); }

    // change all ops to single words, remove "What is" and "?"
    let q = question.slice(0, -1).replace(/by /gi, "").split(" ").splice(2);

    // if nothing remaining after the clean
    if (q.length !== 0) { throw new Error('Syntax error'); }

    let ans = "";

    // numbers and operations should alternate in n-o-n-o-n-... pattern
    for (let i = 0; i < q.length; i++){
      const iOps = ops[q[i]];

      if (i % 2 !== 1) {
        // duplicated operation
        if (typeof(iOps) !== "undefined") { throw new Error('Syntax error'); }

        // eval is done per iteration bc ignoring BEDMAS; directly eval left to right
        if (i === 0) {
          ans = eval(q[0]);
        } else {
          ans = eval(ans + q.slice(i - 1, i + 1).join(" "));
        }
      } else {
        // unsupported operation
        if (typeof(iOps) === "undefined") { throw new Error('Unknown operation'); }
        q[i] = iOps;
      }
    }

    // technically if the length of the statement is even, there's an error
    // could be unsupported operation or missing operand
    // since they're different errors,
    // this error statement is outside and after the for loop
    if (q.length % 2 === 0) { throw new Error('Syntax error'); }

    return ans;
  } else {
    throw new Error('Unknown operation');
  }
};
