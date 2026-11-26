sub caesar-cipher ( :$text, :$shift-key ) is export {

    $text.trans: map { $_ => rotate .List, $shift-key }, 'A'..'A', 'a'..'z'

}