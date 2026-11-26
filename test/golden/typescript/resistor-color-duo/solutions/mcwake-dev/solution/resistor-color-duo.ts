interface Band {
  color: string,
  value: number
}

interface Bands {
  bands: Band[]
}

const resistors: Bands = {
  bands: [
    { color: "black", value: 0 },
    { color: "brown", value: 1 },
    { color: "red", value: 2 },
    { color: "orange", value: 3 },
    { color: "yellow", value: 4 },
    { color: "green", value: 5 },
    { color: "blue", value: 6 },
    { color: "violet", value: 7 },
    { color: "grey", value: 8 },
    { color: "white", value: 9 },
  ]
}

export function decodedValue(encodedValue: string[] = ["none", "none"]): number {
  return parseInt(encodedValue.slice(0, 2).map(
    color => resistors.bands
      .filter(band => band.color === color)
      .reduce((acc, band) => `${acc}${band.value}`,"")
  ).reduce((acc, value) => `${acc}${value}`));
}
