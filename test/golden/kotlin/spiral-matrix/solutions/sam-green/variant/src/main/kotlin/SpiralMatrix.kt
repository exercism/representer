package SpiralMatrix

fun ofSize(size: Int): Array<IntArray> {
    if (size == 0) return emptyArray()
    val matrix = Array(size) { IntArray(size) }
    val dx = intArrayOf(0, 1, 0, -2)
    val dy = intArrayOf(1, 0, -1, 0)
    var x = 0
    var y = -1
    var count = 1
    for (i in 0 until size + size) {
        for (j in 0 until (size + size - i) / 2) {
            x += dx[i % 4]
            y += dy[i % 4]
            matrix[x][y] = count++
        }
    }
    return matrix
}