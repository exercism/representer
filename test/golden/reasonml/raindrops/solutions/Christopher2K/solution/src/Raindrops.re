type translator = (int, string)

let translators: Js.Array.t(translator) = [|
    (3, "Pling"),
    (5, "Plang"),
    (7, "Plong")
|]

let hoc_use_translators: int => (string, translator) => string = number => {
    (translation: string, item: translator) => {
        let (factor, raindrop) = item
        number mod factor === 0 ? translation ++ raindrop : translation
    }
}

let raindrops: int => string = number => {
    let translation = Js.Array.reduce(hoc_use_translators(number), "", translators)
    translation->String.length === 0 ? number->Js.Int.toString : translation
}  
