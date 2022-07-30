require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.size < 1

    mid = array.size / 2
    root = Node.new(array[mid])
    root.left_child = build_tree(array[0...mid])
    root.right_child = build_tree(array[(mid+1)...array.size])

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end
