update anagram
set result = (
    with
    target as (
        select group_concat(c, '') as word
        from (
            select lower(substr(subject, value, 1)) c
            from generate_series(1, length(subject))
            order by c
        )
    ),
    chars_by_key as (
        select words.key, lower(substr(words.value, cs.value, 1)) as c
        from json_each(candidates) words, generate_series(2, length(words.value)) cs
        order by words.key, c
    ),
    sorted_words_by_key as (
        select key, group_concat(c, '') as word
        from chars_by_key
        group by key
    ),
    remaining_keys as (
        select key
        from sorted_words_by_key sorted, target
        where sorted.word = target.word
    )
    select json_group_array(candidates->key) filter (where lower(candidates->>key) != lower(subject))
    from remaining_keys
)