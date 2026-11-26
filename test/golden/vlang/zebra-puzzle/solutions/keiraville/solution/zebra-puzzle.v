module main

struct PermutationIter[T] {
mut:
    a []T
    started bool
}

fn PermutationIter.new[T](a []T) PermutationIter[T] {
    return PermutationIter[T]{
        a: a
    }
}

fn (mut iter PermutationIter[T]) next() ?[]T {
    if !iter.started {
        iter.started = true
        return iter.a
    }

    n := iter.a.len
    if n <= 1 {
        return none
    }

    mut j := n - 2
    for iter.a[j] >= iter.a[j+1] {
        if j == 0 {
            return none
        }
        j--
    }

    mut l := n - 1
    for iter.a[j] >= iter.a[l] {
        l--
    }
    iter.a[j], iter.a[l] = iter.a[l], iter.a[j]

    mut k := j + 1
    l = n - 1
    for k < l {
        iter.a[k], iter.a[l] = iter.a[l], iter.a[k]
        k++
        l--
    }
    return iter.a
}

enum Color as u8 {
    blue
    green
    ivory
    red
    yellow
}

enum Drink as u8 {
    coffee
    milk
    orange_juice
    tea
    water
}

enum Hobby as u8 {
    chess
    dancing
    football
    painting
    reading
}

enum Nationality as u8 {
    englishman
    japanese
    norwegian
    spaniard
    ukrainian
}

enum Pet as u8 {
    dog
    fox
    horse
    snails
    zebra
}

struct Solution {
	water_drinker Nationality
	zebra_owner Nationality
}

fn name(nationality Nationality) string {
	return match nationality {
	    .englishman { "Englishman" }
	    .japanese { "Japanese" }
	    .norwegian { "Norwegian" }
	    .spaniard { "Spaniard" }
	    .ukrainian { "Ukrainian" }
	}
}

fn find[T](haystack []T, needle T) int {
	mut index := 0
	for haystack[index] != needle {
		index++
	}
	return index
}

fn adjacent(first int, second int) bool {
	return first + 1 == second || second + 1 == first
}

fn solution() Solution {
	// 1. There are five houses.

	mut color_iter := PermutationIter.new[Color]([
	    Color.blue,
	    .green,
	    .ivory,
	    .red,
	    .yellow
	])

	for colors in color_iter {
		// 6. The green house is immediately to the right of the ivory house.
		if find(colors, Color.green) + 1 != find(colors, Color.ivory) {
			continue
		}

		mut drink_iter := PermutationIter.new[Drink]([
		    Drink.coffee,
		    .milk,
		    .orange_juice,
		    .tea,
		    .water
		])	

		for drinks in drink_iter {
			// 4. The person in the green house drinks coffee.
			if find(colors, Color.green) != find(drinks, Drink.coffee) {
				continue
			}

			// 9. The person in the middle house drinks milk.
			if find(drinks, Drink.milk) != 2 {
				continue
			}

			mut hobby_iter := PermutationIter.new[Hobby]([
			    Hobby.chess,
			    .dancing,
			    .football,
			    .painting,
			    .reading
			])	

			for hobbies in hobby_iter {
				// 8. The person in the yellow house is a painter.
				if find(colors, Color.yellow) != find(hobbies, Hobby.painting) {
					continue
				}

				// 13. The person who plays football drinks orange juice.
				if find(hobbies, Hobby.football) != find(drinks, Drink.orange_juice) {
					continue
				}

				mut nationality_iter := PermutationIter.new[Nationality]([
				    Nationality.englishman,
				    .japanese,
				    .norwegian,
				    .spaniard,
				    .ukrainian
				])	

				for nationalities in nationality_iter {
					// 2. The Englishman lives in the red house.
					if find(nationalities, Nationality.englishman) != find(colors, Color.red) {
						continue
					}

					// 5. The Ukrainian drinks tea.
					if find(nationalities, Nationality.ukrainian) != find(drinks, Drink.tea) {
						continue
					}

					// 10. The Norwegian lives in the first house.
					if find(nationalities, Nationality.norwegian) != 0 {
						continue
					}

					// 14. The Japanese person plays chess.
					if find(nationalities, Nationality.japanese) != find(hobbies, Hobby.chess) {
						continue
					}

					// 15. The Norwegian lives next to the blue house.
					if !adjacent(find(nationalities, Nationality.norwegian), find(colors, Color.blue)) {
						continue
					}

					mut pet_iter := PermutationIter.new[Pet]([
					    Pet.dog,
					    .fox,
					    .horse,
					    .snails,
					    .zebra
					])

					for pets in pet_iter {
						// 3. The Spaniard owns the dog.
						if find(nationalities, Nationality.spaniard) != find(pets, Pet.dog) {
							continue
						}

						// 7. The snail owner likes to go dancing.
						if find(pets, Pet.snails) != find(hobbies, Hobby.dancing) {
							continue
						}

						// 11. The person who enjoys reading lives in the house next to the person with the fox.
						if !adjacent(find(hobbies, Hobby.reading), find(pets, Pet.fox)) {
							continue
						}

						// 12. The painter's house is next to the house with the horse.
						if !adjacent(find(hobbies, Hobby.painting), find(pets, Pet.horse)) {
							continue
						}

						return Solution {
							water_drinker: nationalities[find(drinks, Drink.water)]
							zebra_owner: nationalities[find(pets, Pet.zebra)]
						}
					}
				}
			}
		}
	}

	return solution()
}

fn drinks_water() string {
	return name(solution().water_drinker)
}

fn owns_zebra() string {
	return name(solution().zebra_owner)
}
