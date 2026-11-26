module React
  abstract class Cell
    @dependents = [] of ComputeCell
    abstract def value : Int32
    abstract def depth : Int32

    protected def add_dependent(cell : ComputeCell)
      @dependents << cell
    end

    protected def collect_dependents(cells : Set(ComputeCell))
      @dependents.each do |cell|
        next if cells.includes?(cell)
        cells << cell
        cell.collect_dependents(cells)
      end
    end

    protected def propagate
      cells = Set(ComputeCell).new
      collect_dependents(cells)
      sorted = cells.to_a.sort_by!(&.depth)
      changed_cells = sorted.select(&.recalculate)
      changed_cells.each(&.fire_callbacks)
    end
  end

  class InputCell < Cell
    getter value : Int32

    def initialize(@value : Int32)
    end

    def value=(number : Int32)
      return if number == @value
      @value = number
      propagate
    end

    def depth : Int32
      0
    end
  end

  class ComputeCell < Cell
    getter value : Int32
    getter depth : Int32
    @compute : Proc(Int32)
    @callbacks = [] of Proc(Int32, Nil)

    def initialize(input : Cell, &block : Int32 -> Int32)
      @compute = -> { block.call(input.value) }
      @depth = input.depth - 1
      @value = @compute.call
      input.add_dependent(self)
    end

    def initialize(input1 : Cell, input2 : Cell, &block : Int32, Int32 -> Int32)
      @compute = -> { block.call(input1.value, input2.value) }
      @depth = {input1.depth, input2.depth}.max + 1
      @value = @compute.call
      input1.add_dependent(self)
      input2.add_dependent(self)
    end

    def add_callback(&block : Int32 -> _) : Proc(Int32, Nil)
      callback = ->(value : Int32) do
        block.call(value)
        nil
      end
      @callbacks << callback
      callback
    end

    def remove_callback(callback : Proc(Int32, Nil))
      @callbacks.delete(callback)
    end

    protected def recalculate : Bool
      old_value = @value
      @value = @compute.call
      @value != old_value
    end

    protected def fire_callbacks
      @callbacks.each do |callback|
        callback.call(@value)
      end
    end
  end
end
