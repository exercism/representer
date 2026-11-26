//
// This is only a SKELETON file for the 'Linked List' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class Node{
  constructor(value){
    this.prev=null
    this.value=value
    this.next=null
  }
}

export class LinkedList {
  constructor(){
    this.head = null
    this.tail = null
    this.size = 0
  }
  
  push(value) {
    let newNode=new Node(value)
    if (this.head===null && this.tail ===null){
      this.head=this.tail=newNode
    }else{
      this.tail.next=newNode
      newNode.prev=this.tail
      this.tail=newNode
    }
    this.size++
  }
  
  pop() {
    if (this.head===null && this.tail ===null) return null
    else if (this.head===this.tail){
      let node=this.head
      this.head=this.tail=null
      this.size--
      return node.value
    }else{
      let node=this.tail
      this.tail=this.tail.prev
      this.tail.next=null
      this.size--
      return node.value
    }
  }

  shift() {
    if (this.head===null && this.tail ===null) return null
    else if (this.head===this.tail) return this.pop()
    else{
      let node=this.head
      this.head=this.head.next
      this.head.prev=null
      this.size--
      return node.value
    }
  }

  unshift(value) {
    let newNode=new Node(value)
    if (this.head===null && this.tail ===null) this.push(value)
    else{
      newNode.next=this.head
      this.head.prev=newNode
      this.head=newNode
      this.size++
    }
  }

  delete(value) {
    if(this.head===null && this.tail ===null) return null
    else if (this.head===this.tail) {
      if(this.head.value===value) this.pop()
    }
    else if (this.head.value===value) this.shift()
    else if(this.tail.value===value) this.pop()
    else{
      let node=this.head
      while (node!==null && node.value!==value) node=node.next
      let prevNode=node.prev,nextNode=node.next
      prevNode.next=nextNode
      nextNode.prev=prevNode
      this.size--
    }
  }

  count() {
    return this.size
  }
}
