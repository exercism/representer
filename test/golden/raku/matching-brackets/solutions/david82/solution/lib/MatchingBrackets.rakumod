unit module MatchingBrackets;

constant %pairs = (
    ']' => '[',
    '}' => '{',
    ')' => '(',
);

sub has-matching-brackets ($string --> Bool) is export {
    my @stack;

    for $string.comb {
        when /<[ ( { [ ]>/ {
            @stack.push($_);
        }
        when /<[ ) } \] ]>/ {
            return False unless @stack && @stack.pop eq %pairs{$_};
        }
    }

    @stack.elems == 0;
}