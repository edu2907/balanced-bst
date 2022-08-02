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
