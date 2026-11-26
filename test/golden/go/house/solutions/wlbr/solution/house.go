package house

var subjects = []string{
	"", // index 0 is unused, subjects are 1-indexed
	"the house that Jack built",
	"the malt",
	"the rat",
	"the cat",
	"the dog",
	"the cow with the crumpled horn",
	"the maiden all forlorn",
	"the man all tattered and torn",
	"the priest all shaven and shorn",
	"the rooster that crowed in the morn",
	"the farmer sowing his corn",
	"the horse and the hound and the horn",
}

var actions = []string{
	"", // index 0 is unused
	"that lay in",
	"that ate",
	"that killed",
	"that worried",
	"that tossed",
	"that milked",
	"that kissed",
	"that married",
	"that woke",
	"that kept",
	"that belonged to",
}

func Verse(v int) string {
	if v == 1 {
		return "This is the house that Jack built."
	}
	parts := make([]string, v)
	parts[0] = "This is " + subjects[v]
	for i := 1; i <= v-1; i++ {
		parts[i] = actions[v-i] + " " + subjects[v-i]
	}
	parts[v-1] += "."
	result := ""
	for i, part := range parts {
		if i > 0 {
			result += "\n"
		}
		result += part
	}
	return result
}

func Song() string {
	verses := make([]string, 12)
	for i := 1; i <= 12; i++ {
		verses[i-1] = Verse(i)
	}
	result := ""
	for i, v := range verses {
		if i > 0 {
			result += "\n\n"
		}
		result += v
	}
	return result
}

