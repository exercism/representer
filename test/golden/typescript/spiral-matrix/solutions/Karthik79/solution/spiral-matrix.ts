export function ofSize(size: number): number[][] {
    if (size === 0) {
        return []
    }
    return spiral(size)
}
function spiral(size: number): number[][] {
    const matrix = Array.from(Array(size), _ => [...Array(size)].fill(-1))
    let direction = 0, x = 0, y = 0, value = 1
    matrix[0][0] = value++
    while (value <= matrix.length ** 2) {
        const [dx, dy] = nextPosition(x, y, direction)
        if (matrix[dy] && matrix[dy][dx] && matrix[dy][dx] === -1) {
            matrix[dy][dx] = value++
            x = dx
            y = dy
        }
        else {
            direction = (direction + 1) % 4
        }
    }
    return matrix
}
function nextPosition(x: number, y: number, direction: number): [number, number] {
    const DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    return [x + DIRECTIONS[direction][0], y + DIRECTIONS[direction][1]]
}
