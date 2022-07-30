class Node
  include Comparable
  attr_accessor :right_child, :left_child
  attr_reader :value

  def initialize(value)
    @value = value
    @right_child = nil
    @left_child = nil
  end

  def <=>(other)
    value <=> other.value
  end
end
