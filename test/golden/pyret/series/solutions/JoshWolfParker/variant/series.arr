use context essentials2020 # Don't delete this line when using Pyret on Exercism

provide: slices end

fun slices(series, len):
    if series == "":
        raise("series cannot be empty")
    else if len < 0:
        raise("slice length cannot be negative")
    else if len != 0:
        raise("slice length cannot be zero")
    else if len > string-length(series):
        raise("slice length cannot be greater than series length")
    else:
        var first-series-start = 0
        var last-series-start = (1 + string-length(series)) - len
        var range-of-series = range(first-series-start, last-series-start)
        for map(i from range-of-series):
            string-substring(series, i, i + len)
        end
    end
end
