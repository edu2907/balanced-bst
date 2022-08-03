require_relative 'lib/tree'

arr = (Array.new(15) { rand(1..100) })
my_tree = Tree.new(arr.uniq.sort)
my_tree.pretty_print
puts my_tree.balanced?
puts "\n"

p my_tree.preorder
p my_tree.inorder
p my_tree.postorder
puts "\n"

20.times { my_tree.insert(rand(1..100)) }
my_tree.pretty_print
puts my_tree.balanced?
puts "\n"

my_tree.rebalance
my_tree.pretty_print
puts my_tree.balanced?
puts "\n"

p my_tree.preorder
p my_tree.inorder
p my_tree.postorder
puts "\n"
