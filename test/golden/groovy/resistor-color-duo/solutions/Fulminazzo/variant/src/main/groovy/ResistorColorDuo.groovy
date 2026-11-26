class ResistorColorDuo {
    static colors = [
        'black', 'brown', 'red', 'orange', 'yellow',
        'green', 'blue', 'violet', 'grey', 'white'
    ]

    static int value(List<String> colorsInput) {
        return Integer.parseInt(colorsInput.subList(0, Math.min(3, colorsInput.size()))
                                .collect { colors.indexOf(it) }
                                .join('')
                                )
    }

}