sub caesar-cipher ( :$text, :$shift-key ) is export {
    $text.trans: |('a'..'z', 'A'..'A').map: { $_ => .List.rotate: $shift-key }
}