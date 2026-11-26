export const rows = (letter) => {
    const alphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    const index = alphabets.split('').findIndex((a) => a === letter)
    const lettersToBeUsed = alphabets.substr(0, index + 1)

    const sideLength = (lettersToBeUsed.length - 1) * 2

    let output = []

    const midIndex = parseInt(sideLength / 2)

    for (let i = 0; i <= sideLength; i++) {
        let letterIndex
        if (i < lettersToBeUsed.length) {
            letterIndex = i
        } else {
            letterIndex = sideLength - i
        }

        let row = ''

        for (let k = 0; k <= sideLength; k++) {
            if (i === 0 || i === sideLength) {
                if (k !== midIndex) {
                    row += ' '
                } else {
                    row += lettersToBeUsed[0]
                }
            } else {
                if (
                    k === midIndex - letterIndex ||
                    k === midIndex + letterIndex
                ) {
                    row += lettersToBeUsed[letterIndex]
                } else {
                    row += ' '
                }
            }
        }

        output.push(row)
    }
    return output
}
