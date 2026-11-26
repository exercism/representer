USING: combinators regexp sequences sets ;
IN: matching-brackets

: paired? ( str -- ? )
    "{[()]}" within
    [ R/ \(\)|\[\]|\{\}/ "" re-replace ] to-fixed-point empty? ;