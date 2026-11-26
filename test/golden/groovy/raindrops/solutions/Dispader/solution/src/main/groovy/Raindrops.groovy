class Raindrops {
    
    public String convert(Integer integer) {
        [ 3:'Pling', 5:'Plang', 7:'Plong' ].collect() { factor, sound ->
            integer % factor == 0 ? sound : ''
        }.join() ?: integer
    }

}