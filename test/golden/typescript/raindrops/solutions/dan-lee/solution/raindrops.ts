export const convert = (input: number): string => {
  const result = []
  if (input % 3 === 0) result.push('Pling')
  if (input % 5 === 0) result.push('Plang')
  if (input % 7 === 0) result.push('Plong')

  return result.length > 0 ? result.join('') : String(input)
}
