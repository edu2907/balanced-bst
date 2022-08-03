require_relative 'lib/tree'

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
my_tree = Tree.new(arr.uniq.sort)
my_tree.pretty_print

my_tree.insert(10)
my_tree.pretty_print

my_tree.delete(10)
my_tree.pretty_print

my_tree.delete(23)
my_tree.pretty_print

my_tree.delete(67)
my_tree.pretty_print

my_tree.insert(6)
my_tree.pretty_print
my_tree.delete(4)
my_tree.pretty_print

my_tree.delete(8)
my_tree.pretty_print

my_tree.level_order { |node| puts node }
p my_tree.level_order
puts "\n"

my_tree.preorder { |node| puts node }
p my_tree.preorder
puts "\n"

my_tree.inorder { |node| puts node }
p my_tree.inorder
puts "\n"

my_tree.postorder { |node| puts node }
p my_tree.postorder
puts "\n"

puts my_tree.height
puts "\n"

my_tree.pretty_print
test_node1 = my_tree.find(1)
test_node2 = my_tree.find(324)
puts my_tree.height(test_node1)
puts my_tree.height(test_node2)
puts "\n"
puts my_tree.depth(test_node1)
puts my_tree.depth(test_node2)
puts "\n"

my_tree.pretty_print
puts my_tree.balanced?
puts "\n"

my_tree.delete(6)
my_tree.delete(7)

my_tree.pretty_print
puts my_tree.balanced?
puts "\n"

my_tree.rebalance
my_tree.pretty_print
puts my_tree.balanced?
