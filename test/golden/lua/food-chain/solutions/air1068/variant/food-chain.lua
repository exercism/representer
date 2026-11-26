local song = {}

song.residents = {
	"fly",
	"spider",
	"bird",
	"cat",
	"dog",
	"goat",
	"cow",
	"horse"}
song.commentary = {
	"",
	"It wriggled and jiggled and tickled inside her.\n",
	"How absurd to swallow a bird!\n",
	"Imagine that, to swallow a cat!\n",
	"What a hog, to swallow a dog!\n",
	"Just opened her throat and swallowed a goat!\n",
	"I don't know how she swallowed a cow!\n",
	"She's dead, of course!\n"}

function song.verse(input)
	local r = "I know an old lady who swallowed a "..song.residents[input]..".\n"..song.commentary[input]
	if input > 7 then
		return r
	end
	while input > 1 do
		r = r.."She swallowed the "..song.residents[input].." to catch the "
		input = input - 1
		r = r..song.residents[input]
		if input == 2 then
			r = r.." that wriggled and jiggled and tickled inside her"
		end
		r = r..".\n"
	end
	return r.."I don't know why she swallowed the fly. Perhaps she'll die.\n"
end

function song.verses(a, b)
	local r = song.verse(a).."\n"
	while a <= b do
		a = a + 1
		r = r..song.verse(a).."\n"
	end
	return r
end

function song.sing()
	return song.verses(1, 8)
end

return song