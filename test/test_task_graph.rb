require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

require 'task_graph'

describe TaskGraph do
  before do
    @graph = TaskGraph.new
  end

  describe 'node' do
    it 'has the method' do
      assert_respond_to @graph, :node
    end

    it 'takes a string and a weight' do
      @graph.node('abc', 1)
    end

    it 'can be detected using the node? method' do
      assert_respond_to @graph, :node?
      @graph.node('abc', 1)
      assert @graph.node?('abc')
    end

    it 'returns the graph for method chaining' do
      assert @graph.node('abc', 1) == @graph
    end
  end

  describe 'edge' do
    it 'has the method' do
      assert_respond_to @graph, :edge
    end

    it 'raises an exception if the left node is not present in the graph' do
      assert_raises TaskGraph::NodeNotFoundException do
        @graph
          .node('a', 1)
          .edge('b', 'a')
      end
    end

    it 'raises an exception if the right node is not present in the graph' do
      assert_raises TaskGraph::NodeNotFoundException do
        @graph
          .node('a', 1)
          .edge('a', 'b')
      end
    end

    it 'raises an exception if the right node explicitly depends on the left node' do
      assert_raises TaskGraph::CyclicDependencyException do
        @graph
          .node('a', 1)
          .node('b', 1)
          .edge('a', 'b')
          .edge('b', 'a')
      end
    end

    it 'raises an exception if the right node implicitly depends on the left node' do
      assert_raises TaskGraph::CyclicDependencyException do
        @graph
          .node('a', 1)
          .node('b', 1)
          .node('c', 1)
          .edge('a', 'b')
          .edge('b', 'c')
          .edge('c', 'a')
      end
    end

    it 'returns the graph for method chaining' do
      @graph
        .node('a', 1)
        .node('b', 1)

      assert @graph.edge('a', 'b') == @graph
    end
  end

  describe 'edge?' do
    it 'has the method' do
      assert_respond_to @graph, :edge?
    end

    it 'returns true if the left node has an edge to the right node' do
      @graph
        .node('abc', 1)
        .node('def', 1)
        .edge('abc', 'def')

      assert @graph.edge?('abc', 'def')
    end

    it 'returns false if the left node has no edge to the right node' do
      @graph
        .node('abc', 1)
        .node('def', 1)

      refute @graph.edge?('abc', 'def')
    end

    it 'returns false if the left node is not present' do
      @graph.node('def', 1)

      refute @graph.edge?('abc', 'def')
    end

    it 'returns false if the right node is not present' do
      @graph.node('abc', 1)

      refute @graph.edge?('abc', 'def')
    end
  end

  describe 'potential_value' do
    it 'has the method' do
      assert_respond_to @graph, :potential_value
    end

    it 'is the value of the node if nothing depends on the node' do
      assert_equal 5, @graph.node('a', 5).potential_value('a')
    end
  end

  describe 'dependency?' do
    it 'has the method' do
      assert_respond_to @graph, :dependency?
    end

    it 'returns true if the two nodes have a direct edge' do
      @graph
        .node('a', 1)
        .node('b', 1)
        .edge('a', 'b')

      assert @graph.dependency?('a', 'b')
    end

    it 'dependency is transitive' do
      @graph
        .node('a', 1)
        .node('b', 1)
        .node('c', 1)
        .node('d', 1)
        .edge('a', 'b')
        .edge('b', 'c')
        .edge('c', 'd')

      assert @graph.dependency?('a', 'b')
      assert @graph.dependency?('a', 'c')
      assert @graph.dependency?('a', 'd')
    end

    it 'returns false if the left node does not exist' do
      @graph
        .node('a', 1)
        .node('b', 1)
        .edge('a', 'b')

      refute @graph.dependency?('c', 'a')
    end

    it 'returns false if the right node does not exist' do
      @graph
        .node('a', 1)
        .node('b', 1)
        .edge('a', 'b')

      refute @graph.dependency?('a', 'c')
    end
  end
end
