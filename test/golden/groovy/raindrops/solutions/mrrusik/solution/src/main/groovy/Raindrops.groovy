class Raindrops {

  def convert(num) {

    String str = ""
         //throw new UnsupportedOperationException('Method implementation is missing')
      if ( num % 3 == 0 ){
      // str.concat('Pling')
      str += 'Pling'
      }

      if ( num % 5 == 0){
        str += 'Plang'
      }

      if ( num % 7 == 0){
          str += 'Plong'
      }
      if (!str.isEmpty()){
        return str
      }


     return num.toString()

  }

  // println (convert(1))

}
