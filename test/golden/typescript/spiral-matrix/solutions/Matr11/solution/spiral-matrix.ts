export function ofSize(size: number) {
  
  let count = 1
  let startRow = 0
  let endRow = size - 1
  let startColumn = 0
  let endColumn = size - 1
  const result = [] as number [][]

  for(let i = 0;i < size; i++){
    result.push([])
  }
  while (startRow <= endRow && startColumn <= endColumn) {
    
    for(let i = startColumn; i <= endColumn; i++) {
      result[startRow][i] = count
      count ++
    }
    startRow ++
    
    for(let i = startRow; i <= endRow; i++) {
      result[i][endColumn] = count
      count ++
    }
    endColumn --

    for(let i = endColumn; i >= startColumn; i--) {
      result[endRow][i] = count
      count ++
    }
    endRow --

    for(let i = endRow; i >= startRow; i--) {
      result[i][startColumn] = count
      count ++
    }
    startColumn ++
    
  }
  return result
}
