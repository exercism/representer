enum class Classification {
    DEFICIENT, PERFECT, ABUNDANT
}

fun classify(naturalNumber: Int): Classification {
    require(naturalNumber > 0)

    val number = (1 until naturalNumber).fold(0, { total, element ->
        if (naturalNumber.rem(element) == 0) {
            total + element
        } else {
            total
        }
    })

    return when {
        number == naturalNumber -> return Classification.PERFECT
        number > naturalNumber -> return Classification.ABUNDANT
        number < naturalNumber -> return Classification.DEFICIENT
        else -> Classification.PERFECT
    }
}
