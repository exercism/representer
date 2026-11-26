sub convert-base (
    :%bases! where .values.all > 2,
    :@digits! where 0 <= .all < %bases<from>
) is export {
    reduce(* × %bases<from> + *, 0, |@digits).polymod(%bases<to> xx *).reverse.List or (0,)
}
