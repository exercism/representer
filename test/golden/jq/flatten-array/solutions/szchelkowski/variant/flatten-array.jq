(
    [
        .array
        | recurse(
            if type == "array" then
                .[]
            else
                empty
            end
        )
        | select(type == "array" and . != null)
    ]
)
