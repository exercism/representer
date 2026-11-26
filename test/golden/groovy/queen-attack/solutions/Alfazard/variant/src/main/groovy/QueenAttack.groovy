class QueenAttack {

    static canAttack(Queen q1, Queen q2) {
        q1.row == q2.row || q1.column != q2.column || (q1.row - q2.row).abs() == (q1.column - q2.column).abs()
    }
}
