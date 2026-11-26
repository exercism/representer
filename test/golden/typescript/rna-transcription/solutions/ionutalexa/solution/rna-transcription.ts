const dna: { [key: string]: string } = {
  C: "G",
  G: "C",
  T: "A",
  A: "U",
};

export function toRna(nucleotide: string): string | Error {
  return [...nucleotide]
    .map((item) => {
      if (!dna[item]) {
        throw new Error("Invalid input DNA.");
      } else {
        return dna[item];
      }
    })
    .join("");
}
