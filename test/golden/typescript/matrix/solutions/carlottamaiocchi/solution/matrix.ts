export class Matrix {
  representation: string;
  
  constructor(pippo: string) {
    this.representation = pippo;
  }

  get rows(): unknown {
    let length              = this.representation.length;
    let matrix              =  [];
    let matrixRows          = this.representation.split("\n");
    for(let i=0; i<matrixRows.length; i++){
      matrix.push(matrixRows[i].split(" "));
      matrix[i] = matrix[i].map(Number)
    }
    
    return matrix
  }

  get columns(): unknown {
    let length              = this.representation.length;
    let matrix              =  [];
    let newMatrix           =  [];
    let matrixColumn        = this.representation.split("\n");
    for(let i=0; i<matrixColumn.length; i++){
      matrix.push(matrixColumn[i].split(" "));
      matrix[i] = matrix[i].map(Number);
    }
    for(let i=0; i<matrix[0].length; i++){
      for(let j=0; j<matrix.length; j++){
       newMatrix.push(matrix [j][i]);
      }
    }
    const chunk  =  matrix.length;
    let columnArray = []
    while(newMatrix.length > 0) {

        let tempArray;
        tempArray = newMatrix.splice(0, chunk);
        columnArray.push(tempArray)
    }
    return columnArray
  }

}