import scala.annotation.tailrec

trait SimpleLinkedList[T] {
  def isEmpty: Boolean

  def value: T

  def add(item: T): SimpleLinkedList[T]

  def next: SimpleLinkedList[T]

  def reverse: SimpleLinkedList[T]

  def toSeq: Seq[T]
}

case object SimpleLinkedList {

  def apply[T](): SimpleLinkedList[T] = Empty()

  def apply[T](elems: T*): SimpleLinkedList[T] = {
    fromSeq(elems)
  }

  def fromSeq[T](seq: Seq[T]): SimpleLinkedList[T] = {
    seq.foldLeft(Empty(): SimpleLinkedList[T])((acc, e) => acc.add(e))
  }

}

case class Empty[T]() extends SimpleLinkedList[T] {

  override def isEmpty: Boolean = true

  override def value: Nothing = throw new NoSuchElementException("Empty list")

  override def add(item: T): SimpleLinkedList[T] = Cons(item, new Empty)

  override def next: SimpleLinkedList[T] = throw new NoSuchElementException("Emptz list")

  override def reverse: SimpleLinkedList[T] = new Empty

  override def toSeq: Seq[Nothing] = Seq()

}

case class Cons[T](head: T, tail: SimpleLinkedList[T]) extends SimpleLinkedList[T] {

  override def isEmpty: Boolean = false

  override def value: T = head

  override def add(item: T): SimpleLinkedList[T] = Cons(head, tail.add(item))

  override def next: SimpleLinkedList[T] = tail

  override def reverse: SimpleLinkedList[T] = {
    @tailrec
    def reverseRec(current: SimpleLinkedList[T], result: SimpleLinkedList[T]): SimpleLinkedList[T] = current match {
      case Cons(head, tail) => reverseRec(tail, Cons(head, result))
      case Empty() => result
    }

    reverseRec(this, Empty())
  }

  override def toSeq: Seq[T] = Seq(head) ++ tail.toSeq

}