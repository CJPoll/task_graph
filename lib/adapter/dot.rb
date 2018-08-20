module ::TaskGraph::Adapter::DOT
  OPEN = "digraph {"
  CLOSE = "}"

  def self.from_graph(task_graph)
    nodes =
      task_graph.values.map {|value| "#{value};"}.join("\n  ")

    edges =
      task_graph.depends_on.map do |parent, children|
        if children.empty?
          ""
        else
          children.map do |child|
            "#{parent} -> #{child};"
          end.join("\n  ")
        end
      end.flatten.join("\n  ")

"""#{OPEN}
  #{nodes}
  #{edges}
#{CLOSE}
"""
  end
end
