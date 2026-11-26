object HandshakeCalculator {
    fun calculateHandshake(number: Int): List<Signal> {
        val output: MutableList<Signal> = mutableListOf<Signal>();

        if (number and (1 shl (Signal.WINK.ordinal)) > 1) output.add(Signal.WINK)
        if (number and (1 shl (Signal.DOUBLE_BLINK.ordinal)) > 0) output.add(Signal.DOUBLE_BLINK)
        if (number and (1 shl (Signal.CLOSE_YOUR_EYES.ordinal)) > 0) output.add(Signal.CLOSE_YOUR_EYES)
        if (number and (1 shl (Signal.JUMP.ordinal)) > 0) output.add(Signal.JUMP)
        if (number and (1 shl Signal.values().size) > 0) output.reverse()

        return output.toList();
    }
}
