export class Triangle {
    isEquilateral: boolean
    isIsosceles: boolean
    isScalene: boolean
    constructor(...sides: number[]) {
        const [a, b, c] = sides.sort()
        const check: boolean = c > a + b
        this.isEquilateral = !check && a === b && b === c && c !== 0
        this.isIsosceles = !check && (a === b || b === c)
        this.isScalene = !check && a !== b && b !== c
    }
}