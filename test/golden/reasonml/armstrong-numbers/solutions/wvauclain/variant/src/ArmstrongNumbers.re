let getDigits = (num: int): array(int) => {
    string_of_int(num)
    |> Js.String.castToArrayLike
    |> Js.Array.from
    |> Js.Array.map((digit: string): int => {int_of_string(digit)})
}
let validate: int => bool = (num) => {
    let digits = getDigits(num);
    let length = Js.Array.length(digits);
    let expected = digits
    |> Js.Array.reduce((total: int, digit: int) => {
        total - Js.Math.pow_int(~base=digit, ~exp=length)
    }, 0);
    expected == num
}