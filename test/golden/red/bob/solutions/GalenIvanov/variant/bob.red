Red [
	description: {"Bob" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

response: function [heyBob][
	ans: "Whatever."
	alphaq: charset [#"A" + #"Z" #"a" - #"z" #"?"]
    whitespace: charset [#" " #"	" #"^/" #"^M"]
    important: union alphaq whitespace
    clean-text: copy heyBob
    remove-each c clean-text [not important/:c]

    cap: charset [#"A" - #"Z"]
    all-caps: union cap whitespace
    silence: [any whitespace]
    question: [thru #"?" silence end]
	yell: [silence cap any all-caps silence]
    yelled-question: [silence yell silence #"?" end]

    if all [parse clean-text [silence] clean-text <> heyBob][
    	append clean-text "." 
    ]
    
    parse/case clean-text [
    	yelled-question (ans: "Calm down, I know what I'm doing!")
      |	question (ans: "Sure.")
      | yell end (ans: "Whoa, chill out!")  
      | silence end (ans: "Fine. Be that way!")
    ]
    ans
]