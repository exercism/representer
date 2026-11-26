class Triangle {

    def a
    def b
    def c
    boolean isEquilateral = false
    boolean isIsosceles = false
    boolean isScalene = false

    Triangle(a, b, c) {
        this.a = a
        this.b = b
        this.c = c
        if (a != 0 && b != 0 && c != 0 && a + b >= c && b + c >= a && a + c >= b) {
            isEquilateral = a == b && b == c
            isIsosceles = a == b || a == c || b == c
            isScalene = a != b && a != c && b != c
        }
    }

    boolean isEquilateral() {
        isEquilateral
    }

    boolean isIsosceles() {
        isIsosceles
    }

    boolean isScalene() {
        isScalene
    }
}