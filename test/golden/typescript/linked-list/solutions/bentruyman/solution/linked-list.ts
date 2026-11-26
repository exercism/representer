export class LinkedList<TElement> {
  private list: TElement[] = [];

  public push(element: TElement) {
    this.list.push(element);
  }

  public pop(): TElement | undefined {
    return this.list.pop();
  }

  public shift(): TElement | undefined {
    return this.list.shift();
  }

  public unshift(element: TElement) {
    this.list.unshift(element);
  }

  public delete(element: TElement) {
    this.list = this.list.filter((item) => item !== element);
  }

  public count(): number {
    return this.list.length;
  }
}
