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
    root.right_child = build_tree(array[(mid + 1)...array.size])

    root
  end

  def insert(value)
    new_node = Node.new(value)
    insert_rec(new_node, @root)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  private

  def insert_rec(new_node, current_node, root_node = current_node, path = nil)
    if current_node.nil?
      link_node(new_node, root_node, path)
      return nil
    end
    next_path = node_path(current_node, new_node)
    next_node = pick_child(current_node, next_path)
    insert_rec(new_node, next_node, current_node, next_path)
  end

  def node_path(root_node, new_node)
    new_node < root_node ? 'left' : 'right'
  end

  def pick_child(node, path)
    case path
    when 'left' then node.left_child
    when 'right' then node.right_child
    end
  end

  def link_node(new_node, root_node, path)
    case path
    when 'left' then root_node.left_child = new_node
    when 'right' then root_node.right_child = new_node
    end
  end
end
