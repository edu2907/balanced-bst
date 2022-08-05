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
    binary_search(new_node) do |node|
      if new_node < node
        node.left_child.nil? ? node.left_child = new_node : false
      elsif new_node > node
        node.right_child.nil? ? node.right_child = new_node : false
      else
        # When the new_node already exists in tree
        return
      end
    end
  end

  def delete(value)
    rm_node = find(value)
    return if rm_node.nil?

    parent_node = find_parent(rm_node.value)
    if rm_node == @root
      @root = find_replacement(rm_node)
    elsif rm_node <= parent_node
      parent_node.left_child = find_replacement(rm_node)
    else
      parent_node.right_child = find_replacement(rm_node)
    end
  end

  def find(value)
    req_node = Node.new(value)

    binary_search(req_node) { |node| node == req_node }
  end

  def find_parent(value)
    child = Node.new(value)

    binary_search(child) { |node| node.left_child == child || node.right_child == child }
  end

  def level_order
    arr = []

    queue = [@root]
    until queue.empty?
      node = queue.shift
      block_given? ? yield(node.value) : arr << node.value
      queue.push(node.left_child) unless node.left_child.nil?
      queue.push(node.right_child) unless node.right_child.nil?
    end

    return arr unless block_given?
  end

  def inorder(node = @root, arr = [], &block)
    return if node.nil?
    
    inorder(node.left_child, arr, &block)
    arr << node.value
    yield(node.value) if block_given?
    inorder(node.right_child, arr, &block)

    return arr unless block_given?
  end

  def preorder(node = @root, arr = [], &block)
    return if node.nil?

    arr << node.value
    yield(node.value) if block_given?
    preorder(node.left_child, arr, &block)
    preorder(node.right_child, arr, &block)

    return arr unless block_given?
  end

  def postorder(node = @root, arr = [], &block)
    return if node.nil?

    postorder(node.left_child, arr, &block)
    postorder(node.right_child, arr, &block)
    arr << node.value
    yield(node.value) if block_given?

    return arr unless block_given?
  end

  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    [left_height, right_height].max + 1
  end

  def depth(searching_node, current_node = @root, depth_count = 0)
    return if current_node.nil?
    return depth_count if searching_node == current_node

    left_depth = depth(searching_node, current_node.left_child, depth_count + 1)
    right_depth = depth(searching_node, current_node.right_child, depth_count + 1)
    [left_depth, right_depth].compact.first
  end

  def balanced?
    balanceHeight(@root) != 1
  end

  def rebalance
    arr = inorder
    @root = build_tree(arr)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  private

  # Auxiliar methods

  # Realize a binary search and return when a given condition is true
  def binary_search(searching_node, current_node = @root, &condition)
    return if current_node.nil?
    return current_node if yield(current_node)

    next_node =  searching_node < current_node ? current_node.left_child : current_node.right_child
    binary_search(searching_node, next_node, &condition)
  end

  # Finds the substitute for the rm_node
  def find_replacement(rm_node)
    if children_of(rm_node).size < 2
      replacement = children_of(rm_node).first
    else
      replacement = find_lowest(rm_node.right_child)
      delete(replacement.value)
      replacement.left_child = rm_node.left_child
      replacement.right_child = rm_node.right_child unless rm_node.right_child == replacement
    end
    replacement
  end

  # Find the lowest child, starting from node
  def find_lowest(node)
    return node if node.left_child.nil?

    find_lowest(node.left_child)
  end
  
  # Return direct node childs, that aren't nil
  def children_of(node)
    [node.left_child, node.right_child].compact
  end

  # Auxiliar recursive function for #balanced?, returns -1 if tree is unbalanced
  def balanceHeight(current_node)
    return 0 if current_node.nil?

    left_height = balanceHeight(current_node.left_child)
    right_height = balanceHeight(current_node.right_child)
    return -1 if (left_height == -1) || (right_height == -1)
    return -1 if (left_height - right_height).abs > 1

    [left_height, right_height].max + 1
  end
end
