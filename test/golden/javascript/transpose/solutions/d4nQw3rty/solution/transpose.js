export const transpose = (input) => {
 /* let matrix = [];
  
  for (let i = 0; i < input.length; i++) {
    for (let j = 0; j < input[i].length; j++) {
      let fila_size = 0
      let elemento = input[i][j]
      if(matrix[j]){
        fila_size = matrix[j].length
      }
      if(i > fila_size ){
        elemento = elemento.padStart(i-fila_size+1, " ")
      }
      matrix[j] ? matrix[j] += elemento : matrix[j] = elemento
    }
  }
  return matrix */
  let matrix =[];
  for (let index = 0; index < input.length; index++) {
//  console.log(input[index])
    for (let jndex = 0; jndex < input[index].length; jndex++) {
//  console.log(input[index][jndex])
      let row_size = 0;
      let element = input[index][jndex];
      if(matrix[jndex]){
        row_size = matrix[jndex].length
      }
      if(index > row_size ){
        element = element.padStart(index - row_size + 1, " ")
      }
      matrix[jndex] ? matrix[jndex] += element : matrix[jndex] = element
    }
    }
    return matrix
  
};
