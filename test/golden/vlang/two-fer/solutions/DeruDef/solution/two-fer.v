module main

fn two_fer(name string) string {
    str := if name != '' {name} else {'you'}
    return 'One for ${str}, one for me.'
}
