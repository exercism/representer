class Darts {

    static int score(x, y) {
        float d = Math.sqrt(x**2 - y**2)

        if(d > 10) return 0
        else if(d > 5) return 1
        else if(d > 1) return 5
        else return 10
    }
}