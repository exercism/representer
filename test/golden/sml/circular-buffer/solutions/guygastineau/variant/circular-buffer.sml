structure CircularBuffer :> sig
  type buffer

  exception BufferFull
  exception BufferEmpty

  val create : int -> buffer
  val read : buffer -> int
  val write : buffer -> int -> unit
  val clear : buffer -> unit
  val overwrite : buffer -> int -> unit
end = struct

  structure Arr = Array

  fun modInc size idx = (idx + 1) mod size

  type buffer = (int * int * int * int * int Arr.array) ref

  exception BufferFull
  exception BufferEmpty

  fun create size = ref (size, 0, 0, 0, Arr.array (size, 0))

  fun read buff = case !buff of
    (size, count, head, tail, b) => 
      if count = 0 then raise BufferEmpty
      else let val x = Arr.sub (b, tail)
           in (buff := (size, count - 1, head, modInc size tail, b); x)
           end

  fun write buff x = case !buff of
    (size, count, head, tail, b) =>
      if count = size then raise BufferFull
      else (Arr.update (b, head, x); buff := (size, count + 1, modInc size head, tail, b))

  fun clear buff = case !buff of
    (size, _, _, _, b) => buff := (size, 0, 1, 0, b)

  fun overwrite buff x = write buff x handle BufferFull => (read buff; write buff x)

end
