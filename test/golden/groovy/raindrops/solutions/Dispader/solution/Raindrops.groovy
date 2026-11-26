class Raindrops {

    String convert(Integer integer) {
        [ 3:'Pling', 5:'Plang', 7:'Plong' ].collect { factor, sound ->
            integer % factor ? '' : sound
        }.join() ?: integer
    }

}