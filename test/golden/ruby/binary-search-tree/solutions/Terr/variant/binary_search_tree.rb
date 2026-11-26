class Bst
  attr_accessor :data, :left, :right

  def initialize(value)
    @data = value
  end

  def insert(value)
    parent_node = find_parent_node(value)

    if value <= parent_node.data
      raise ArgumentError.new "Left not null" if parent_node.left

      parent_node.left = Bst.new(value)
    else
      raise ArgumentError.new "Right not null" if parent_node.right

      parent_node.right = Bst.new(value)
    end
  end

  def each(&block)
    return to_enum(:each) unless block_given?

    @left.each(&block) if @left
    yield(@data)
    @right.each(&block) if @right
  end

  protected

  def find_parent_node(value)
    if value < @data
      return @left.find_parent_node(value) if @left
    else
      return @right.find_parent_node(value) if @right
    end

    self
  end
end
