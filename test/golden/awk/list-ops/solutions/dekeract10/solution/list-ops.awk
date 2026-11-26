@namespace "listops"

# Append to a list all the elements of another list.
# Or append to a list a single new element
function append(list, item_or_list) {
    if (awk::isarray(item_or_list)) {
        count = length(list) + 1
        for (i in item_or_list){
            list[count] = item_or_list[i]
            count = count + 1
        }
    } else {
        count = length(list) + 1
        list[count] = item_or_list
    }
}

# Concatenate is flattening a list of lists one level
function concat(list, result) {
    count = 1
    for (i in list) {
        for (j in list[i]) {
            result[count] = list[i][j]
            count++
        }
    }
}

# Only the list elements that pass the given function.
function filter(list, funcname, result) {
    for (i in list) {
        if (@funcname(list[i])) {
            append(result, list[i])
        }
    }
}

# Transform the list elements, using the given function, into a new list.
function map(list, funcname, result) {
    for (i in list){
        result[i] = @funcname(list[i])
    }
}

# Left-fold the list using the function and the initial value.
function foldl(list, funcname, initial) {
    result = initial
    for (i in list) {
        result = @funcname(result, list[i])
    }
    return result
}

# Right-fold the list using the function and the initial value.
function foldr (list, funcname, initial) {
    result = initial
    for (i = length(list); i > 0; i--) {
        result = @funcname(list[i], result)
    }
    return result
}

# the list reversed
function reverse (list, result) {
    count = 1
    for (i = length(list); i > 0; i--) {
        result[count] = list[i]
        count++
    }
}
