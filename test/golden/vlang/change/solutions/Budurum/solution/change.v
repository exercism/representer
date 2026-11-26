module main

import arrays

fn find_fewest_coins(coins []int, target int) ![]int {

    if target < 0 { return error("target can't be negative")}
    if target == 0 { return []int{} }
    if smaller_than_smallest(coins, target) { return error("can't make target with given coins")}

    answer := get_coin_set(coins, target) or { return error("can't make target with given coins") }
    return answer
}

fn smaller_than_smallest(coins []int, target int) bool {
    if target < coins[0] { return true }
    else { return false }
}

fn get_indexation_array(num int) []int {
    mut arr := []int{}
    for i := 0; i < num; i++ {
        arr << 0
    }
    return arr 
}

fn get_max_sum(last_index int, num int, arr [][]int) int {
    mut test_arr := []int{}
    for i in 0..num {
        test_arr << arr[i][last_index]
    }

    mx_sum := arrays.sum[int](test_arr) or {return 0}

    return mx_sum 
}

fn get_min_sum(num int, arr [][]int) int {
    mut test_arr := []int{}
    for i in 0..num {
        test_arr << arr[i][0]
    }

    mn_sum := arrays.sum[int](test_arr) or {return 0}

    return mn_sum
}

fn get_test_array(num int, index_arr []int, arr [][]int) []int {
    mut test_arr := []int{}
    for i in 0..num {
        j := index_arr[i]
        test_arr << arr[i][j]
    }

    return test_arr
}


fn get_coin_set(set []int, target int) ![]int {

    mut finished := false
	mut met_target := false
	mut answer := []int{}

	size_of_set := set.len

	mut levels_of_sets := [set]
	mut number_of_levels := levels_of_sets.len

    for !met_target {

		mut indexation := get_indexation_array(number_of_levels)
        for !finished {
            max_sum := get_max_sum(size_of_set - 1, number_of_levels, levels_of_sets)
            min_sum := get_min_sum(number_of_levels, levels_of_sets)

            if min_sum > target {
                return error("can't make target with given coins")
            }
            else if max_sum < target {
				finished = true
			}
			else {

				mut test_array := get_test_array(number_of_levels, indexation, levels_of_sets)

				test_sum := arrays.sum[int](test_array) or {return [0]}

				if test_sum == target {
					met_target = true
					finished = true
					answer = test_array.clone()
				}
				else {

					mut reverse_iter_a := number_of_levels - 1
					for reverse_iter_a > -1 {
						indexation[reverse_iter_a]++
						if indexation[reverse_iter_a] < size_of_set { 
							if reverse_iter_a < number_of_levels - 1 {
								reverse_iter_b := reverse_iter_a + 1
								for position_2 in reverse_iter_b..number_of_levels{
									indexation[position_2] = indexation[reverse_iter_a]
								}
							}
							reverse_iter_a = -1 
						}
						else if indexation[reverse_iter_a] == size_of_set && reverse_iter_a == 0 {
							finished = true
							reverse_iter_a = -1
						}
						reverse_iter_a--
					}
				}
			}
		}

		levels_of_sets << set
		number_of_levels = levels_of_sets.len
		finished = false

	}

    return answer
}