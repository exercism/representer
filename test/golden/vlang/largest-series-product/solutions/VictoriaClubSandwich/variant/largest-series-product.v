module main

fn largest_product(digits string, span int) !int {

    if span > digits.len {
        return error('span must be smaller than string length')
    }
    if span < 0 {
        return error('span must not be negative')
    }

    mut max_series_calc := 0

    for i in 0 .. digits.len - span + 1 {

        series := digits.substr(i, i+ span)
        mut series_calc := 1 

        for j in 0 .. series.len {

            if series[j] <= 48 || series[j] > 57 {
                return error('digits input must only contain digits')
            }
            series_calc *= series[j].ascii_str().int()
        }
        if series_calc > max_series_calc {
            max_series_calc = series_calc
        }
                    
    } 
    return max_series_calc

}
