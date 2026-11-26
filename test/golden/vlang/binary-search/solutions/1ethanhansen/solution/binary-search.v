module main

pub fn find(array []int, value int) !int {
    mut i := 0
    mut k := array.len - 1
    mut mid := i + (k-i) / 2

    for i <= k {
        if array[mid] == value {
            return mid
        } else if value < array[mid] {
            k = mid - 1
        } else {
            i = mid + 1
        }
        mid = i + (k-i) / 2
        println("i: $i \t k: $k \t mid: $mid")
    }
    return error("value not in array")
}

fn main() {
    // println(find([6], 6)!)
    // println(find([1, 3, 4, 6, 8, 9, 11], 6)!)
    // println(find([1, 3, 4, 6, 8, 9, 11], 1)!)
    // println(find([1, 3, 4, 6, 8, 9, 11], 11)!)
    // println(find([1, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 634], 144)!)
    println(find([1, 3, 4, 6, 8, 9, 11], 7)!)
}