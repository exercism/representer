const words = ['wink', 'double blink', 'close your eyes', 'jump'];

export function commands(input: number): Array<string> {
    const binary = (input >>> 0).toString(2);
    if (binary.length > 5) throw new Error('unable to process more than 5 bits');

    const handshake: Array<string> = [];
    for (let i = binary.length - 1, j = 0; i >= 0; i--, j++) {
        if (binary[i] === '1') {
            if (j === 4) handshake.reverse();
            else handshake.push(words[j]);
        }
    }

    return handshake;
}
