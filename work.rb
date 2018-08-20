require 'task_graph'

graph =
  TaskGraph.new
  .node('a', 1)
  .node('b', 1)
  .node('c', 1)
  .edge('a', 'c')

str = TaskGraph::Adapter::DOT.from_graph(graph)

puts str

f = File.new('work.dot', 'w')
f.write str
f.close
