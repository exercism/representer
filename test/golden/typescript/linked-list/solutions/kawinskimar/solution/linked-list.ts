class Node<T> {
  prev: Node<T> | undefined;
  next: Node<T> | undefined;
  value: T;

  constructor(value: T) {
    this.value = value;
  }
}

export class LinkedList<T> {
  head: Node<T> | undefined;
  tail: Node<T> | undefined;
  length: number = 0;

  public push(element: any): void {
    const node: Node<T> = new Node<T>(element);
    
    if(this.length == 0) {
      this.head = node;
      this.tail = node;
    } else {
      this.tail!.next = node;
      node.prev = this.tail;
      this.tail = node;
    }

      this.length++;
  }

  public pop(): T {
    const temp = this.tail;
    this.tail = this.tail!.prev;
    
    this.length--;
    return temp!.value;
  }

  public shift(): any {
    const temp = this.head;
    this.head = this.head!.next;
    
    this.length--;
    return temp!.value;
  }

  public unshift(element: any) {
    const node: Node<T> = new Node<T>(element);
    if(this.length == 0) {
      this.head = node;
      this.tail = node;
    } else {
      this.head!.prev = node;
      node.next = this.head;
      this.head = node;
    }

      this.length++;
  }

  public delete(element: any) {
    let curr = this.head;
    if(this.length == 1 && curr!.value == element) {
      this.head = undefined;
      this.tail = undefined;
      this.length = 0;
    } else {
        while(curr!.next != undefined) {
        if(curr!.value == element) {
            curr!.next!.prev = curr!.prev!.next;
          this.length--;
          break;
        }
        curr = curr!.next;
      }
    }
  }

  public count(): number {
    return this.length;
  }
}
