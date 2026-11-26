const romanMapping: [number, string][] = [
  [1000, 'M'],
  [900, 'CM'],
  [500, 'D'],
  [400, 'CD'],
  [100, 'C'],
  [90, 'XC'],
  [50, 'L'],
  [40, 'XL'],
  [10, 'X'],
  [9, 'IX'],
  [5, 'V'],
  [4, 'IV'],
  [1, 'I']
]

export const toRoman = (number: number): string => {
  return romanMapping.reduce<string>((res, [n, roman]) => {
    while(number >= n){
      res = res + roman
      number-=n
    }
    return res
  }, '')
}
