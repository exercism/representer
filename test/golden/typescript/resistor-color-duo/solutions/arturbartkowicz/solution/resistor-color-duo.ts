let COLORS = ['black','brown','red','orange','yellow','green','blue','violet','grey','white'] as const

type COLOR = typeof COLORS[number];

export function decodedValue([color1, color2]: [COLOR, COLOR, ...COLOR[]]) {
    return COLORS.indexOf(color1)*10 + COLORS.indexOf(color2)
}