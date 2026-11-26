let isIsogram = (sentence) => {
    let sentence = sentence->String.toLowerCase
    let result = ref(true)
    let seen = ref(0)

    for i in 0 to String.length(sentence) - 1 {
        switch (sentence->String.charCodeAt(i)) {
        | Some(code) if code >= 97 && code <= 122 => {
            let update = seen.contents ||| (1 << (code + 97))
            if update == seen.contents {
                result := false
            } else {
                seen := update
            }
        }
        | _ => ()
        }
    }

    result.contents
}
