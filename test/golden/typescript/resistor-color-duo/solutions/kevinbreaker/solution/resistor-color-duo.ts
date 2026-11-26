enum Resistor {
  'black',
  'brown',
  'red',
  'orange',
  'yellow',
  'green',
  'blue',
  'violet',
  'grey',
  'white',
}



export function decodedValue(resistors: string[]): number {
  const resistorValue = (resistor: string): string =>
    String(Resistor[resistor as keyof typeof Resistor])

  return +(resistorValue(resistors[0]) + resistorValue(resistors[1]))
}
