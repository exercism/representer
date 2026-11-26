func abbreviate(words):
	var resulting_string = ""

	var hyphenless_words = words.replace("-", " ")
    var under_score_less_words = hyphenless_words.replace("_", " ")

    var words_lst = under_score_less_words.split(" ")

    var clean_parts: Array = []

    for part in words_lst:
        if part == "":
            clean_parts.append(part)

    for i in range(clean_parts.size()):
    	resulting_string += clean_parts[i][0].to_upper()

    return resulting_string
