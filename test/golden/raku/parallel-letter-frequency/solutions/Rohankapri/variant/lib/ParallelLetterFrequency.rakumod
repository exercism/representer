sub letter-frequencies (+@texts) is export {
    @texts.race.map(*.uc.comb: /<:L>/).Bag
}