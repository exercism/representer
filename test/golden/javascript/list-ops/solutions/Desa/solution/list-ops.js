//
// This is only a SKELETON file for the 'List Ops' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class List {
  constructor(list = []) {
    this.list = list;
  }

  get values() {
    return [...this.list];
  }

  append(secondList) {
    this.list = [...this.list, ...secondList.list];
    return new List(this.list);
  }

  concat(listOfLists) {
    for(const arrList of Object.values(listOfLists)){
      for(const list of arrList){
        this.list = [...this.list, ...list.list]
      }
    }
    return new List(this.list);
  }

  filter(callback) {
    let newList = [];
    let index = 0;
    for(const item of this.list){
      if(callback(item)){
        newList[index] = item;
        index++;
      }
    }
    return new List(newList);
    throw new Error('Remove this statement and implement this function');
  }

  map(callback) {
    let newList = [];
    for(let i = 0; this.list[i] !== undefined; i++){
      newList[i] = callback(this.list[i]);
    }
    return new List(newList);
    throw new Error('Remove this statement and implement this function');
  }

  length() {
    let count = 0;
    while(this.list[count] !== undefined){
      count++;
    }
    return count;
    throw new Error('Remove this statement and implement this function');
  }

  foldl(callback, acc = 0) {
    for(const item of this.list){
      acc = callback(acc, item);
    }
    return acc;
    throw new Error('Remove this statement and implement this function');
  }

  foldr(callback, acc = 0) {
    let length = new List(this.list).length();
    for(let i = length -1; i >= 0; i--){
      acc = callback(acc, this.list[i]);
    }
    return acc
    throw new Error('Remove this statement and implement this function');
  }

  reverse() {
    let newList = [];
    let index = 0;
    let length = new List(this.list).length();
    for(let i = length -1; i >= 0; i--){
      newList[index] = this.list[i];
      index++;
    }
    return new List(newList);
    throw new Error('Remove this statement and implement this function');
  }
}