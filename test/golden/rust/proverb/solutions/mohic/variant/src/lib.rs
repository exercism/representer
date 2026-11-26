pub fn build_proverb(list: &[&str]) -> String {
    let mut strings = Vec::with_capacity(list.len());

    list.windows(2)
        .map(|x| format!("For want of a {} the {} was lost.", x[1], x[1]))
        .for_each(|s| strings.push(s));

    if !list.is_empty() {
        strings.push(format!("And all for the want of a {}.", list[0]))
    }

    strings.join("\n")
}
