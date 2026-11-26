include std/text.e

public function score(sequence word)
    atom score = 0
    word = upper(word)
    for i = 1 to length(word) label "by_letter" do
        atom char = word[i]
        sequence letters = {"AEIOULNRST","DG","BCMP","FHVWY","K","","","JX","","QZ"}
        for L = 2 to length(letters) do 
            if find(char, letters[L]) then
                score += L
                continue "by_letter"
            end if
        end for
    end for
    return score
end function
