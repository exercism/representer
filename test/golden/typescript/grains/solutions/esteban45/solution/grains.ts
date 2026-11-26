export const square = (n: number): BigInt => {
    if (n > 64) throw Error()

    return BigInt(2 ** (n - 1))
}

export const total = (): BigInt => BigInt(2 ** 64) - BigInt(1)