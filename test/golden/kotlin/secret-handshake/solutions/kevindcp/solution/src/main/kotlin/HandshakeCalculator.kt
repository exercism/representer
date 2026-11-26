import java.security.KeyStore.TrustedCertificateEntry

object HandshakeCalculator {
    fun calculateHandshake(number: Int): List<Signal> {
        var binary: String = Integer.toBinaryString(number)
        var len: Int = binary.length - 1
        var handshake = mutableListOf<Signal>()
        while (len >= 0){
            when (len) {
                3 -> if (binary.reversed()[len] == '1') handshake.add(Signal.JUMP)
                2 -> if (binary.reversed()[len] == '1') handshake.add(Signal.CLOSE_YOUR_EYES)
                1 -> if (binary.reversed()[len] == '1') handshake.add(Signal.DOUBLE_BLINK)
                0 -> if (binary.reversed()[len] == '1') handshake.add(Signal.WINK)
            }
            len -= 1
        }
        if (binary.length - 1 == 4 && binary[binary.length - 1] == '1') return handshake
        return handshake.reversed()
    }
}
