require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

require 'stack'

describe Stack do
  before do
    @stack = Stack.new
  end

  describe 'push' do
    it 'has the method' do
      assert_respond_to @stack, :push
    end

    it 'returns the stack for method chaining' do
      assert @stack.push(1) == @stack
    end
  end

  describe 'peek' do
    it 'has the method' do
      assert_respond_to @stack, :peek
    end

    it 'shows the last pushed value' do
      @stack.push(1)

      assert @stack.peek == 1
    end

    it 'has no side effects' do
      @stack.push(1)

      assert @stack.peek == 1
      assert @stack.peek == 1
      assert @stack.peek == 1
    end

    it 'returns nil if stack is empty' do
      assert @stack.peek == nil
    end
  end

  describe 'pop' do
    it 'has the method' do
      assert_respond_to @stack, :pop
    end

    it 'returns the stack for method chaining' do
      assert @stack.push(1).pop == @stack
    end

    it 'removes the last pushed value' do
      val =
        @stack
        .push(1)
        .push(2)
        .pop
        .peek

      assert val == 1
    end

    it 'has no side effects if the stack is empty' do
      @stack.pop
    end
  end

  describe 'include?' do
    it 'has the method' do
      assert_respond_to @stack, :include?
    end

    it 'returns true if the value is in the stack' do
      assert @stack.push(1).include?(1) == true
    end

    it 'returns false if the value was never in the stack' do
      assert @stack.push(1).include?(2) == false
    end

    it 'returns false if the value was removed from the stack' do
      assert @stack.push(1).pop.include?(1) == false
    end
  end
end
