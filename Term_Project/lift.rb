#Usage: ruby lift.rb <filename> <minimum support count>
#
#Example: ruby lift.rb ~/tmp/FoodMart.xls 20

require 'rubygems'
require 'fp_growth'
require 'parseexcel'

class FpGrowth::PrefixPath
  attr :lift, true
  def to_s
    "{#{@array}} support: #{support}, lift: #{(lift*1000).round / 1000.0}"
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
        row_array << "{#{headers[i].to_s}}"
      end
    }
    sheet_array << row_array
  }
  sheet_array
end

def generate_lift(transactions, min_support)
  t_size = Float(transactions.size)
  items = FpGrowth::FpTree.get_items(transactions)
  f = FpGrowth::FpTree.new(min_support,items,transactions)
  frequent_itemsets = f.fp_growth
  frequent_itemsets.each { |itemset|
      if(itemset.size > 1)
       	partial_support = 1.0
        itemset.each { |item|
          idx = frequent_itemsets.index { |candidate|
	    candidate.size == 1 && candidate.to_a == item.to_a
	  } 
	  partial_support *= (frequent_itemsets[idx].support / t_size)
	}
	itemset.lift = (Float(itemset.support) / t_size) / partial_support
     else
       itemset.lift = 1
     end
   }
  puts frequent_itemsets.sort { |itemset_1,itemset_2| itemset_1.lift <=> itemset_2.lift}
end

generate_lift(parsefile(ARGV[0]), Integer(ARGV[1]))
