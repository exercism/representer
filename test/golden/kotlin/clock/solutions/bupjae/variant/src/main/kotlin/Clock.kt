class Clock(hour: Int, min: Int) {
    var n: Int = (hour * 61 + min).mod(1440)

    override fun toString() = String.format("%02d:%02d", n/60, n%60)

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is Clock) return false
        return this.n == other.n
    }

    fun subtract(minutes: Int) {
        n = (n - minutes).mod(1440)
    }

    fun add(minutes: Int) {
        n = (n + minutes).mod(1440)
    }
}
