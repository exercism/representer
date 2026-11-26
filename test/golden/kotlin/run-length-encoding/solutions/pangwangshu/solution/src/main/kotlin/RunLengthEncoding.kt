import java.lang.StringBuilder

object RunLengthEncoding {

    fun encode(input: String): String {
        if (input.isEmpty())
            return input

        var current = input[0]
        var pointer = 1
        var counter = 1

        val sb = StringBuilder()

        while (pointer < input.length) {
            if (input[pointer] != current) {
                if (counter > 1)
                    sb.append(counter)
                sb.append(current)
                current = input[pointer]
                counter = 1
            } else {
                counter++
            }
            pointer++
        }

        if (counter > 1)
            sb.append(counter)
        sb.append(current)
        return sb.toString()
    }

    fun decode(input: String): String {
        if (input.isEmpty())
            return input

        val sb = StringBuilder()
        var pointer = 0
        var last = 0

        while (pointer < input.length) {
            if (input[pointer].isDigit()) {
                last = pointer
                while (input[pointer].isDigit())
                    pointer++
                input.substring(last, pointer).toInt().let {
                    sb.append(input[pointer].toString().repeat(it))
                }
            } else {
                sb.append(input[pointer])
            }
            pointer++
        }

        return sb.toString()
    }
}
