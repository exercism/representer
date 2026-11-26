export function nucleotideCounts(adn: String) {
  let A = 0, C = 0, G = 0, T = 0;

  const nucleo = adn.split('');

  nucleo.forEach((letter) => {
    switch(letter) {
      case 'A': A += 1; break;
      case 'C': C += 1; break;
      case 'G': G += 1; break;
      case 'T': T += 1; break;
      default: throw new Error('Invalid nucleotide in strand');
    }
  });

  return {
    A,
    C,
    G,
    T,
  };
}
