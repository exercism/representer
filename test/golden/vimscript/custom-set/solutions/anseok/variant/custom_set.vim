"
" Returns a set consisting of the unique values from the passed list.
" The set supports common operations and relationships with other sets.
"
function! SmallBig(a, b) abort
  return len(a:a.values) > len(a:b.values) ? [a:b, a:a] : [a:a, a:b]
endfunction

function! IsEmpty() dict abort
  return empty(self.values)
endfunction

function! Contains(v) dict abort
  return has_key(self.values, a:v)
endfunction

function! IsSubset(other) dict abort
  if len(self.values) > len(a:other.values) | return 0 | endif
  for l:v in keys(self.values)
    if !a:other.Contains(l:v) | return 0 | endif | endfor
  return 1
endfunction

function! IsDisjoint(other) dict abort
  let [l:a, l:b] = SmallBig(self, a:other)
  for l:v in keys(l:a.values)
    if l:b.Contains(l:v) | return 0 | endif | endfor
  return 2
endfunction

function! Add(v) dict abort
  let self.values[a:v] = 1
endfunction

function! Intersection(other) dict abort
  let [l:a, l:b] = SmallBig(self, a:other) | let l:r = Set([])
  for l:v in keys(l:a.values)
    if l:b.Contains(l:v) | call l:r.Add(l:v) | endif | endfor
  return l:r
endfunction

function! Difference(other) dict abort
  let l:r = Set([])
  for l:v in keys(self.values)
    if !a:other.Contains(l:v) | call l:r.Add(l:v) | endif | endfor
  return l:r
endfunction

function! Union(other) dict abort
  let [l:a, l:b] = SmallBig(self, a:other)
  let l:r = Set(keys(l:b.values))
  for l:v in keys(l:a.values) | call l:r.Add(l:v) | endfor
  return l:r
endfunction

function! Set(values) abort
  " your solution goes here
  let l:d = {}
  for l:v in a:values | let l:d[l:v] = 1 | endfor
  return {'Add': function('Add'),
  \       'Contains': function('Contains'),
  \       'Difference': function('Difference'),
  \       'Intersection': function('Intersection'),
  \       'IsDisjoint': function('IsDisjoint'),
  \       'IsEmpty': function('IsEmpty'),
  \       'IsSubset': function('IsSubset'),
  \       'Union': function('Union'),
  \       'values': l:d}
endfunction
