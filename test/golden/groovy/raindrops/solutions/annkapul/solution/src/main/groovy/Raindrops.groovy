// If the number has 3 as a factor, output 'Pling'.
// If the number has 5 as a factor, output 'Plang'.
// If the number has 7 as a factor, output 'Plong'.
// If the number does not have 3, 5, or 7 as a factor, just pass the number's digits straight through.

class Raindrops {

    def convert(num) {
        def result_string = ''
        if ( num % 3 == 0 ) { result_string += 'Pling' }
        if ( num % 5 == 0 ) { result_string += 'Plang' }
        if ( num % 7 == 0 ) { result_string += 'Plong' }

        if (result_string == ''){
          return "${num}"
        }
        return result_string
    }
}
