require 'rubygems'
require 'fp_growth'

def fp
min_support = 2
transactions = [
	["milk ","honey "],
	["bread "],
	["milk ","bread "],
	["milk ","bread "]
]
items = FpGrowth::FpTree.get_items(transactions)
f = FpGrowth::FpTree.new(min_support,items,transactions)
puts "\nTree Structure\n\n"
puts f
puts "\nFrequent Itemsets\n\n"
puts f.fp_growth
end

fp
