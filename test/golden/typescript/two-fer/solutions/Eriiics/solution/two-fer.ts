/**
 * This stub is provided to make it straightforward to get started.
 */

export function twoFer(name: string): string {
    let phrase = 'One for you, one for me.'

    if (name) {
        phrase = `One for ${name}, one for me.`
    }

    return phrase
}