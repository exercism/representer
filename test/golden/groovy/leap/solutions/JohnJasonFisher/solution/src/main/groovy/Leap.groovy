class Leap {

    Integer year

    Leap(Integer year) {
        this.year = year
    }

    def isLeapYear() {
        Boolean answer = false

        if (year % 4 == 0) {
            answer = true
        }

        if (year % 100 == 0) {
            answer = false
        }

        if (year % 400 == 0) {
            answer = true
        }

        answer
    }

}
