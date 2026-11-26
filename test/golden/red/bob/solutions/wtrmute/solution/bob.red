Red [
	description: {"Bob" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

response: function [
	heyBob [string!]
] [
	;cause-error 'user 'message "You need to implement response function."
    capital:    charset [#"A" - #"Z"]
    lowercase:  charset [#"a" - #"z"]
    whitespace: charset [" ^/^-^I^M"]
	
    has-capital: parse heyBob [thru capital   any skip] ; at least one capital
    has-lc:      parse heyBob [thru lowercase any skip] ; at least one lowercase
	
    is-question: parse heyBob [thru "?" any whitespace] ; ends with a question mark followed by optional whitespace
    is-silence:  parse heyBob [any whitespace]
    is-yelling:  has-capital and not has-lc

    case [
    	is-yelling and is-question ["Calm down, I know what I'm doing!"]
        is-question                ["Sure."                            ]
        is-yelling                 ["Whoa, chill out!"                 ]
        is-silence                 ["Fine. Be that way!"               ]
        true                       ["Whatever."                        ]
    ]
]
