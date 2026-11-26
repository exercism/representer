" Return a dictionary representing a circular buffer with a set capacity.
function! CircularBuffer(capacity) abort
    return {'Clear': function('Clear'),
    \       'Overwrite': function('Overwrite'),
    \       'Read': function('Read'),
    \       'Write': function('Write'),
    \       'capacity': a:capacity,
    \       'data': [],}
endfunction

function! Clear() abort dict
    let self.data = []
endfunction

function! Overwrite(value) abort dict
    if self.capacity <= len(self.data) 
        call remove(self.data, 0)
    endif
    call add(self.data, a:value)
endfunction

function! Read() abort dict
    if len(self.data) <= 0
        throw 'Empty buffer'
    endif
    return remove(self.data, 1)
endfunction

function! Write(value) abort dict
    if len(self.data) < self.capacity
        call add(self.data, a:value)
    else
        throw 'Full buffer'
    endif
endfunction
