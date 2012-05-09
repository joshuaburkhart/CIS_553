#Usage: ruby fp.rb <filename> <minimum support> <minimum confidence>
#
#Example: ruby fp.rb ~/tmp/FoodMart.xls 20 .60

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
        row_array << headers[i]
      end
    }
    sheet_array << row_array
  }
  sheet_array
end

def fp(transactions, min_support, min_confidence)
  items = FpGrowth::FpTree.get_items(transactions)
  f = FpGrowth::FpTree.new(min_support,items,transactions)
  puts "\nFrequent Itemsets\n\n"
  puts f.fp_growth
  puts "\nStrong Association Rules\n"
  puts FpGrowth::Helper.create_assoziation_rules(f.fp_growth,min_confidence)
end

fp(parsefile(ARGV[0]), Integer(ARGV[1]), Float(ARGV[2]))
