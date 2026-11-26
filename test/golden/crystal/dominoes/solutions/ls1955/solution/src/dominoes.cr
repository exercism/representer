module Dominoes
  def self.can_chain(dominoes : Array(Array(Int32)))
    Graph.euler_cycle? dominoes
  end
end

module Graph
  # TLDR:
  # See if graph is empty or (all degrees are even && we can visit every node)
  def self.euler_cycle?(graph : Array(Array(Int32)))
    return true if graph.empty?

    degrees = graph.reject { |(from, to)| from == to }.flatten.tally

    return false unless degrees.values.all? &.even?

    visited = graph.flatten.uniq.map { |node| [node, false] }.to_h
    adjacent_list = Hash(Int32, Set(Int32)).new { |h, k| h[k] = Set(Int32).new }
    graph.each do |(from, to)|
      adjacent_list[from] << to
      adjacent_list[to] << from
    end
    dfs_visit graph.sample[0], adjacent_list, visited

    visited.values.all?
  end

  def self.dfs_visit(current_node, adjacent_list, visited) : Nil
    return if visited[current_node]

    visited[current_node] = true

    adjacent_list[current_node].each do |node|
      dfs_visit node, adjacent_list, visited
    end
  end
end
