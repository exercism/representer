class RunLengthEncoding {

    static encode(String input) {
        input.replaceAll(/(\D)\1+/) { group, letter ->
            (group.length() > 1) ? "${group.length()}$letter": letter
        }
    }

    static decode(String input) {
        input.replaceAll(/(\d+)(\D)/) { all, count, letter ->
            letter * (count as int)
        }
    }
}