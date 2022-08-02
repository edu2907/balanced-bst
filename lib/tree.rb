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

  def delete(value)
    node = find(value)
    case node
    when nil then nil
    when @root then delete_root
    else
      delete_node(node)
    end
  end

  def find(value)
    req_node = Node.new(value)
    find_rec(req_node)
  end

  def find_parent(value)
    child = Node.new(value)
    find_parent_rec(child)
  end

  def level_order
    unless block_given?
      arr = []
      level_order { |node| arr << node }
      return arr
    end

    queue = [@root]
    until queue.empty?
      node = queue.shift
      yield(node.value)
      queue.push(node.left_child)
      queue.push(node.right_child)
      queue.compact!
    end
  end

  def inorder(node = @root, &block)
    unless block_given?
      arr = []
      inorder { |node| arr << node }
      return arr
    end
    return if node.nil?

    inorder(node.left_child, &block)
    yield(node.value)
    inorder(node.right_child, &block)
  end

  def preorder(node = @root, &block)
    unless block_given?
      arr = []
      preorder { |node| arr << node }
      return arr
    end
    return if node.nil?

    yield(node.value)
    preorder(node.left_child, &block)
    preorder(node.right_child, &block)
  end

  def postorder(node = @root, &block)
    unless block_given?
      arr = []
      postorder { |node| arr << node }
      return arr
    end
    return if node.nil?

    postorder(node.left_child, &block)
    postorder(node.right_child, &block)
    yield(node.value)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  private

  def insert_rec(new_node, current_node, root_node = current_node, path = nil)
    if current_node.nil?
      link(new_node, root_node, path)
      return nil
    end
    next_path = take_path(current_node, new_node)
    next_node = pick_child(current_node, next_path)
    insert_rec(new_node, next_node, current_node, next_path)
  end

  def take_path(current_node, node)
    node <= current_node ? 'left' : 'right'
  end

  def pick_child(node, path)
    case path
    when 'left' then node.left_child
    when 'right' then node.right_child
    end
  end

  def link(new_node, root_node, path)
    case path
    when 'left' then root_node.left_child = new_node
    when 'right' then root_node.right_child = new_node
    end
  end

  def find_rec(req_node, current_node = @root)
    return nil if current_node.nil?
    return current_node if current_node == req_node

    next_path = take_path(current_node, req_node)
    next_node = pick_child(current_node, next_path)
    find_rec(req_node, next_node)
  end

  def find_parent_rec(child, current_node = @root)
    return nil if current_node.nil?
    return current_node if child?(child, current_node)

    next_path = take_path(current_node, child)
    next_node = pick_child(current_node, next_path)
    find_parent_rec(child, next_node)
  end

  def find_next_biggest(node)
    find_next_biggest_rec(node.right_child)
  end

  def find_next_biggest_rec(node)
    return node if node.left_child.nil?

    find_next_biggest_rec(node.left_child)
  end

  def children_of(node)
    [node.left_child, node.right_child].compact
  end

  def child?(node, parent_node)
    children_of(parent_node).include?(node)
  end

  def num_of_children(node)
    children_of(node).size
  end

  def delete_node(rm_node)
    parent_node = find_parent_rec(rm_node)
    path = take_path(parent_node, rm_node)
    case num_of_children(rm_node)
    when 0 then link(nil, parent_node, path)
    when 1 then replacement = children_of(rm_node).first
    when 2
      replacement = find_next_biggest(rm_node)
      delete_node(replacement)
      link(rm_node.left_child, replacement, 'left')
      link(rm_node.right_child, replacement, 'right') unless rm_node.right_child == replacement
    end
    link(replacement, parent_node, path)
  end

  def delete_root
    case num_of_children(@root)
    when 0 then return @root = nil
    when 1 then replacement = children_of(@root).first
    when 2
      replacement = find_next_biggest(@root)
      delete(replacement.value)
      link(@root.left_child, replacement, 'left')
      link(@root.right_child, replacement, 'right') unless @root.right_child == replacement
    end
    @root = replacement
  end
end
