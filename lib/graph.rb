require 'set'
require 'pry'

class TaskGraph
  class NodeNotFoundException < StandardError
    def initialize(msg)
      super
    end
  end

  class CyclicDependencyException < StandardError; end

  attr_reader :depends_on, :values

  def initialize
    @weights = {}
    @values = ::Set.new
    @depends_on = {}
    @depended_by = {}
  end

  def node(value, weight)
    unless node?(value)
      @values << value
      @weights[value] = weight
    end

    self
  end

  def node?(value)
    @values.include?(value)
  end

  def edge(node_a, node_b)
    raise NodeNotFoundException, "#{node_a.inspect} was not found." unless node?(node_a)
    raise NodeNotFoundException, "#{node_b.inspect} was not found." unless node?(node_b)
    raise CyclicDependencyException, "#{node_b.inspect} already depends on #{node_b.inspect}" if dependency?(node_b, node_a)

    add_edge(node_a, node_b, @depends_on)
    add_edge(node_b, node_a, @depended_by)

    self
  end

  def edge?(node_a, node_b)
    return false unless @depends_on.key?(node_a)
    @depends_on[node_a].include?(node_b)
  end

  def potential_value(node)
    sum = 0

    depth_traversal(node, @depended_by, Set.new) do |dependent, weight|
      sum += weight
    end

    sum
  end

  def dependency?(node_a, node_b)
    depth_traversal(node_a, @depends_on, Set.new) do |dep, weight|
      return true if edge?(dep, node_b)
      false
    end

    return false
  end

  private

  def depth_traversal(value, edges, traversed=Set.new, block = Proc.new)
    unless traversed.include?(value)
      block.call(value, @weights[value])
    end

    deps = dependents(value, edges)

    deps.each do |child|
      depth_traversal(child, edges, traversed << value, block)
    end
  end

  def add_edge(node_a, node_b, edges)
    if edges.key?(node_a)
      edges[node_a] << node_b
    else
      edges[node_a] = Set.new([node_b])
    end
  end

  def dependents(child, edges)
    edges.fetch(child, Set.new)
  end
end
