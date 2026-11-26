class Proverb {

    static recite(List<String> strings) {
        StringBuilder sb = new StringBuilder()
        strings.eachWithIndex {entry, index ->
            if (strings.size() - 2 < index) {
                sb << "And all for the want of a ${strings.first()}."
            }
            else {
                sb << "For want of a $entry the ${strings[index+1]} was lost.\n"
            }
        }

        return sb.toString()
    }
}