<#
.SYNOPSIS
Implement the circular buffer data structure.

.DESCRIPTION
A circular buffer, cyclic buffer or ring buffer is a data structure that uses a single, fixed-size buffer as if it were connected end-to-end.
Please implement the circular buffer class with these methods:
- Write     : write new value into the buffer, raise error if the buffer is full.
- Overwrite : overwrite the oldest element in the buffer if the buffer is full, otherwise behave like write.
- Clear     : clear all elements in the buffer, it is now empty.
- Read      : read the oldest element in the buffer, and return its value.

.EXAMPLE
$buffer = [CircularBuffer]::new(2)

$buffer.Write(1)
$buffer.Read()
Return: 1

$buffer.Write(2)
$buffer.Write(3)
$buffer.Overwrite(5)
$buffer.Read()
Return: 5

$buffer.Clear()
$buffer.Read()
Throw "BufferError: Circular buffer is empty"
#>

Class CircularBuffer {
    [array]$buffer
    [int]$head                      # Index of the oldest element in buffer
    [int]$next                      # Index after the newest element in the buffer
    [int]$ItemCount     = 0
    [bool]$BufferEmpty  = $true
    [bool]$BufferFull   = $false
    [int]$UpperBound                # the largest index value allowed
    [int]$Capacity

    CircularBuffer([int32]$capacity) {
        if ($capacity -lt 1){
            Throw "Capacity must be a positive number"
        }
        # create the buffer
        $this.buffer        = [object[]]::new($capacity)
        $this.UpperBound    = $this.buffer.GetUpperBound(0)
        $this.Capacity      = $capacity
    }

    [void] Write([object]$val) {
        if ($this.BufferFull){
            Throw "BufferError: Circular buffer is full"
        }
        $this.buffer[$this.next] = $val
        $this.next++                                        # point to the next position
        $this.ItemCount++                                   # keep track of the number of items in the buffer
        if ($this.ItemCount -eq $this.Capacity){
            $this.BufferFull = $true
        }
        if ($this.next -gt $this.UpperBound){
            $this.next = 0
        }
        $this.BufferEmpty = $false
    }

    [void] Overwrite([object]$val) {
        if (-NOT $this.BufferFull){
            $this.Write($val)
        }
        else{
            $this.buffer[$this.head] = $val
            $this.head++
            if ($this.head -gt $this.UpperBound){
                $this.head = 0
            }
        }
        return
    }

    [void] Clear() {
        $this.buffer.Clear()
        $this.head = 0
        $this.next = 0
        $this.ItemCount = 0
        $this.BufferEmpty = $true
        $this.BufferFull  = $false
    }

    [object] Read() {
        if ($this.BufferEmpty){
            Throw "BufferError: Circular buffer is empty"
        }
        $item = $this.buffer[$this.head]
        $this.buffer[$this.head] = $null            # avoid disclosing any previous information in the buffer
        $this.head++                                # point at the next item to be read
        $this.ItemCount--                           # decrement number of items
        $this.BufferFull = $false
        if ($this.head -gt $this.UpperBound){       # is it beyond the end of the buffer?
            $this.head = 0                          # point to the first item in the buffer
        }
        if ($this.ItemCount -eq 0){                 # the buffer's empty
            $this.BufferEmpty = $true
            $this.head = 0
            $this.next = 0
        }
        return $item
    }
}