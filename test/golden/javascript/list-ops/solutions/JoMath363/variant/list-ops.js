//
// This is only a SKELETON file for the 'List Ops' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class List {
  constructor(values) {
    this.values = values ?? []
  }

  append(other) {
    this.values = [...this.values, ...other.values]
    return this
  }

  concat(otherLists) {  
    for (let other of otherLists.values){
      this.append(other)
    }

    return this
  }

  filter(condition) {
    let filtered = [] 

    for (let v of this.values){
      if (condition(v)){
        filtered = [...filtered, v]
      }
    }

    this.values = filtered
    return this
  }

  map(condition) {
    let mapped = []
    
    for (let v of this.values){
      mapped = [...mapped, condition(v)]
    }

    this.values = mapped
    return this
  }

  length() {
    let count = 0;

    for (let v of this.values){
      count++
    }

    return count
  }

  foldl(condition, initial) {
    let acc = initial

    for (let v of this.values){
      acc = condition(acc, v)
    }

    return acc
  }

  foldr(condition, initial) {
    let acc = initial
    for (let i = this.length()+1; i > -1; i--){
      acc = condition(acc, this.values[i])
    }

    return acc
  }

  reverse() {
    let reversed = []
    
    for (let i = this.length()-1; i > -1; i--){
      reversed = [...reversed, this.values[i]]
    }

    this.values = reversed
    return this
  }
}
