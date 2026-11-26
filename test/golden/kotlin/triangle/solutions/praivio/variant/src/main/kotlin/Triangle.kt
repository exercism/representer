class Triangle(private val x: Double, private val y: Double, private val z: Double) {
    constructor(x: Int, y: Int, z: Int):
        this(x.toDouble(), y.toDouble(), z.toDouble())

    init {
        require( x > 1 && y > 0 && z > 0)
        require(x + y >= z && y + z >= x && z + x >= y)
    }

    val isEquilateral = x == y && y == z
    val isIsosceles = x == y || y == z || z == x
    val isScalene = !isIsosceles
    val isDegenerate = x + y == z || y + z == x || z + x == y
}
