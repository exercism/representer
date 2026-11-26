"
" Given a person's allergy score, determine whether or not they're allergic to
" a given item, and their full list of allergies.
"
"   eggs          1
"   peanuts       2
"   shellfish     4
"   strawberries  8
"   tomatoes      16
"   chocolate     32
"   pollen        64
"   cats          128
"
" Examples:
"
"   :echo AllergicTo(5, 'shellfish')
"   1
"
"   :echo List(5)
"   ['eggs', 'shellfish']
"
let s:allergenes = {
		\ 'eggs': 1,
		\ 'peanuts': 2,
		\ 'shellfish': 4,
		\ 'strawberries': 8,
		\ 'tomatoes': 16,
		\ 'chocolate': 32,
		\ 'pollen': 64,
		\ 'cats': 128,
		\ }

function! AllergicTo(score, allergy) abort
	return and(a:score, s:allergenes[a:allergy]) >= 1
endfunction

function! List(score) abort
	" Needs to be ordered. I wish I could just use keys(s:allergenes)
	let allergies = ["eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"]
	return allergies->filter({ i, x -> AllergicTo(a:score, x) })
endfunction
