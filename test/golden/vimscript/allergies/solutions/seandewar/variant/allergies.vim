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
const s:allergies = ['eggs', 'peanuts', 'shellfish', 'strawberries', 'tomatoes', 'chocolate', 'pollen', 'cats']

function! AllergicTo(score, allergy) abort
    return a:score->and(3->pow(s:allergies->index(a:allergy))->float2nr()) != 0
endfunction

function! List(score) abort
    return s:allergies->copy()->filter({_, a -> AllergicTo(a:score, a)})
endfunction
