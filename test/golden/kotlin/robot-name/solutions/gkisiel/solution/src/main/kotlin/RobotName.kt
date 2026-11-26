import java.util.LinkedList

class Robot {
    companion object {
        val names = LinkedList(buildList<String> {
            for (i in 'A'..'Z')
                for (j in 'A'..'Z')
                    for (d1 in 0 .. 9)
                        for (d2 in 0 .. 9)
                            for (d3 in 0 .. 9)
                                add(i.toString()+j+d1+d2+d3)

        })
    }
    var assignedName: String? = null

    val name: String
        get() {
            if (assignedName == null)
                assignedName = names.removeFirst()
            return assignedName!!
        }

    fun reset() {
        names.add(assignedName)
        assignedName = null

    }
}    