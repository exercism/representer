type Classification = "deficient" | "perfect" | "abundant";

export function classify(num: number): Classification {
  if (num < 1)
    throw new Error("Classification is only possible for natural numbers.");

  let aliquotSum = 0;

  for (let i = 1; i < num; i++) {
    if (num % i === 0) aliquotSum += i;
  }

  if (aliquotSum < num) return "deficient";
  if (aliquotSum === num) return "perfect";
  return "abundant";
}