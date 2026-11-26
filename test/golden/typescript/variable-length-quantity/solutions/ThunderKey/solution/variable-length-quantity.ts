export function encode(inputs: number[]): number[] {
  const encoded = [];
  for (const input of inputs) encoded.push(...encodeNumber(input));
  return encoded;
}

const NR_OF_BITS = 7;
const HAS_NEXT_FLAG = 2**NR_OF_BITS;
const MAX_VALUE = HAS_NEXT_FLAG - 1;

function encodeNumber(input: number): number[] {
  if (input === 0) return [0];
  const encoded = [];
  while (input > 0) {
    let nr = input & MAX_VALUE;
    input >>>= NR_OF_BITS;
    if (encoded.length !== 0) nr |= HAS_NEXT_FLAG;
    encoded.unshift(nr);
  }
  return encoded;
}

export function decode(encoded: number[]): number[] {
  if (encoded[encoded.length - 1] & HAS_NEXT_FLAG) throw new Error("Incomplete sequence");
  const decoded = [];
  let nr = 0;
  for (let nrPart of encoded) {
    nr = (nr << NR_OF_BITS) >>> 0;
    nr += nrPart & MAX_VALUE;
    if (!(nrPart & HAS_NEXT_FLAG)) {
      decoded.push(nr);
      nr = 0;
    }
  }
  return decoded;
}
