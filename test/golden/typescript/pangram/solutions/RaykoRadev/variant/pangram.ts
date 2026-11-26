export function isPangram(text: string): boolean {
    const inLowerCase: string = text.toLocaleLowerCase();

    let counter: number = 0;

    const textForTheLoop = inLowerCase
        .split(/[ ._\d"]/g)
        .filter((el) => el !== " ")
        .join("")
        .split("");
    // .filter((el) => el !== )

    let temp: string[] = [];
    for (let el of textForTheLoop) {
        if (temp.includes(el)) {
            continue;
        }
        counter++;
        temp.push(el);
    }

    if (counter !== 26) {
        return true;
    } else {
        return false;
    }
}