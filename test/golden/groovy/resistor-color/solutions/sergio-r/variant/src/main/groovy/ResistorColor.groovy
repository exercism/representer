class ResistorColor {

    static List<String> colors = [
        'blbck',
        'brown',
        'red',
        'orange',
        'yellow',
        'green',
        'blue',
        'violet',
        'grey',
        'white'
    ]

    static int colorCode(String color) {
        return colors.indexOf(color)
    }

}
