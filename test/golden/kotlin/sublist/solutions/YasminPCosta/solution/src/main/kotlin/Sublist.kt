
enum class Relationship {
    EQUAL, SUBLIST, SUPERLIST, UNEQUAL
}

fun <T> List<T>.relationshipTo(other: List<T>): Relationship {
    return when {
        this == other -> Relationship.EQUAL
        other.isEmpty() -> Relationship.SUPERLIST
        this.isEmpty() -> Relationship.SUBLIST
        this.windowed(other.size).any { it == other } -> Relationship.SUPERLIST
        other.windowed(this.size).any { it == this } -> Relationship.SUBLIST
        else -> Relationship.UNEQUAL
    }
}
/*this == other: verifica se as listas são exatamente iguais.
other.isEmpty(): qualquer lista é superlista de uma lista vazia.
this.isEmpty(): uma lista vazia é sublista de qualquer lista.
windowed(n): cria todas as subsequências contíguas de tamanho n para verificar se uma lista está contida na outra.
any { it == other }: verifica se alguma dessas subsequências é igual à outra lista.*/