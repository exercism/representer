sub count-words ($sentence) is export {
    $sentence.uc.comb(/ \w [ [ \w || \' ] * \w ] ? /).Bag
}
