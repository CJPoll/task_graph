class Stack
  def initialize
    @stack = []
  end

  def push(value)
    @stack << value
    self
  end

  def pop
    @stack.pop
    self
  end

  def peek
    @stack.last
  end

  def include?(value)
    @stack.include?(value)
  end
end
