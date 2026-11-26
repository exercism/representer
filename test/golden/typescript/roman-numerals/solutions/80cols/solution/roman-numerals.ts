export const toRoman = (chif: number): string => {
  let res: string = '';
  let nbr: number = chif %10;
  chif = (chif - chif%10)/10;
  if (nbr === 9) {
    res = 'IX';
    nbr = nbr - 9;
  }
  else if (nbr === 4) {
    res = 'IV';
    nbr = nbr - 4;
  }
  else if (nbr >= 5) {
    res = 'V';
    nbr = nbr - 5;
  }
  for (let i = 0; i < nbr; i++)
    res+='I';

  nbr = chif %10;
  chif = (chif - chif%10)/10;
  let temp: string = '';
  if (nbr === 9) {
    temp = 'XC';
    nbr = nbr - 9;
  }
  else if (nbr === 4) {
    temp = 'XL';
    nbr = nbr - 4;
  }
  else if (nbr >= 5) {
    temp = 'L';
    nbr = nbr - 5;
  }
  for (let i = 0; i < nbr; i++)
    temp+='X';
  res = temp + res;

  nbr = chif %10;
  chif = (chif - chif%10)/10;
  temp = '';
  if (nbr === 9) {
    temp = 'CM';
    nbr = nbr - 9;
  }
  else if (nbr === 4) {
    temp = 'CD';
    nbr = nbr - 4;
  }
  else if (nbr >= 5) {
    temp = 'D';
    nbr = nbr - 5;
  }
  for (let i = 0; i < nbr; i++)
    temp+='C';
  res = temp + res;

  nbr = chif %10;
  chif = (chif - chif%10)/10;
  temp = '';
  for (let i = 0; i < nbr; i++)
    temp+='M';
  res = temp + res;
  return res;
}
