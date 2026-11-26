object Raindrops {

    private data class Noise(val factor: Int, val sound: String) {
        fun maybeMakeANoise(input: Int) = if (input % factor == 0) sound else ""
    }

    private val noises = arrayOf(
            Noise(3, "Pling"),
            Noise(5, "Plang"),
            Noise(7, "Plong")
    )

    fun convert(input: Int): String {
        val sound = noises.fold("") { sound, noise -> sound + noise.maybeMakeANoise(input) }
        return if (sound.isEmpty()) input.toString() else sound
    }
}