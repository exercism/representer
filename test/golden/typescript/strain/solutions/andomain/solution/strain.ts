export function keep<T>(inputElements: T[], predicate: (el: T) => boolean): T[] {
    return inputElements.filter(predicate);
}


export function discard<T>(inputElements: T[], predicate: (el: T) => boolean): T[] {
    return inputElements.filter(el => !predicate(el));
}