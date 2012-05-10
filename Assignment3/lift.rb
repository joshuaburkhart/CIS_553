#Usage: ruby lift.rb <filename> <minimum support count>
#
#Example: ruby lift.rb ~/tmp/FoodMart.xls 20

require 'rubygems'
require 'fp_growth'
require 'parseexcel'

class FpGrowth::PrefixPath
  attr :lift, true
  def to_s
    "[#{@array} :#{support} :#{lift}]"
  end
end

def parsefile(filename)
  workbook = Spreadsheet::ParseExcel.parse(filename)
  worksheet = workbook.worksheet(0)
  headers = worksheet.first
  sheet_array = Array.new
  worksheet.each(1) { |row|
    row_array = Array.new
    row.each_with_index { |cell,i|
      if(cell.to_i == 1)
        row_array << headers[i].to_s
      end
    }
    sheet_array << row_array
  }
  sheet_array
end

def fp(transactions, min_support, min_lift)
  t_size = Float(transactions.size)
  items = FpGrowth::FpTree.get_items(transactions)
  f = FpGrowth::FpTree.new(min_support,items,transactions)
  frequent_itemsets = f.fp_growth
  frequent_itemsets.each { |itemset|
      if(itemset.size > 1)
	#puts "found a frequent itemset of 2 or more"
        #puts "class of itemset = #{itemset.class}"
        #puts "size of itemset = #{itemset.size}"
        #puts "content of itemset = #{itemset}"
        #puts "support of itemset = #{itemset.support}"
       	partial_support = 1.0
        itemset.each { |item|
          #puts "  item = #{item}"
	  #puts "  class of item = #{item.class}"
	  #puts "  size of item = #{item.size}"
	  #puts "  item.to_a = #{item.to_a}"
          idx = frequent_itemsets.index { |candidate|
		  #puts "    comparing to #{candidate}"
		  #puts "    candidate.class = #{candidate.class}"
		  #puts "    item.class = #{item.class}"
		  #puts "    candidate.size = #{candidate.size}"
		  #puts "    candidate.size == 1 ? #{candidate.size == 1}"
		  #puts "    candidate.to_a #{candidate.to_a}"
		  #puts "    candidate.to_a.class #{candidate.to_a.class}"
		  #puts "    candidate.to_a == #{item.to_a} ? #{candidate.to_a == item.to_a}"
		  #puts "    candidate.to_s = #{candidate.to_s}"
		  #puts "    candidate.to_s.class = #{candidate.to_s.class}"
		  #puts "    candidate.to_s.eql? #{item.to_s} ? #{candidate.to_s.eql? item.to_s}"
		  candidate.size == 1 && candidate.to_a == item.to_a
	  } 
	  partial_support *= (frequent_itemsets[idx].support / t_size)
	}
	puts "setting #{itemset}'s lift to #{Float(itemset.support) / t_size} / #{partial_support}"
	itemset.lift = (Float(itemset.support) / t_size) / partial_support
     else
       itemset.lift = 0
     end
   }
  puts frequent_itemsets.sort { |itemset_1,itemset_2| itemset_1.lift <=> itemset_2.lift}
end

fp(parsefile(ARGV[0]), Integer(ARGV[1]))
