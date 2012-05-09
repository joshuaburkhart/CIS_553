#Usage: ruby fp.rb <filename> <minimum support> <minimum confidence>
#
#Example: ruby fp.rb ~/tmp/FoodMart.xls 5 .70

require 'rubygems'
require 'fp_growth'
require 'parseexcel'

def parsefile(filename)
  workbook = Spreadsheet::ParseExcel.parse(filename)
  worksheet = workbook.worksheet(0)
  headers = worksheet.first
  sheet_array = Array.new
  worksheet.each(0) { |row|
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
  items = FpGrowth::FpTree.get_items(transactions)
  f = FpGrowth::FpTree.new(min_support,items,transactions)
  frequent_itemsets = f.fp_growth
  frequent_itemsets.each { |itemset|
      puts "size of itemset = #{itemset.size}"
      puts "content of itemset #{itemset}"
      itemset.each { |item|
	puts "  count of item = #{item.count}"
        puts "  size of item = #{item.size}"
  	puts "  content of item = #{item}"
      }
   }
  puts frequent_itemsets
end

fp(parsefile(ARGV[0]), Integer(ARGV[1]), Float(ARGV[2]))
