enum Color {
  Black, Brown, Red, Orange, Yellow, Green, Blue, Violet, Grey, White
}

export function decodedValue(colors:string[]) {
  const colorsArray = colors.map(color=>color.toLowerCase().replace(color[0],color[0].toUpperCase()));
  return parseInt(`${Color[colorsArray[0] as keyof typeof Color] }${Color[colorsArray[1] as keyof typeof Color]}`)
}
