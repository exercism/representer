class GameOfLife {
  List<List<int>> input;
  GameOfLife(this.input);
  List<List<int>> output = [];

  void tick(){
    int length_ = input.length;
    int neighbors = 0;
    //output = input.map((row) => List<int>.from(row)).toList();
    output = [for (var row in input) [...row]];


    for (var x = 0; x < length_; x++){
      for (var y = 0; y < length_; y++){
        var indiceXY = [
          [x-1, y-1],
          [x-1, y],
          [x-1, y+1],
          [x, y+1],
          [x+1, y+1],
          [x+1, y],
          [x+1, y-1],
          [x, y-1],
        ];
        for (var indice in indiceXY){
          try {
            neighbors += input[indice[0]][indice[1]];
          } catch (_) {} 
        }
        switch (input[x][y]) {
          case 1 : if(neighbors != 2 && neighbors !=3) { output[x][y] = 0;}; break;
          case 0 : if(neighbors == 3) { output[x][y] =  1;} 
        }
        neighbors = 0;
      }
    }
   
  }
 List<List<int>>? matrix(){
    return output;
  }
}