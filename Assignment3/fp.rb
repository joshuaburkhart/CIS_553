#!/usr/local/bin/ruby
#Usage: fp.rb <filename> <support>
#Example: ./fp.rb ~/tmp/FoodMart.xls 20

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

def fp(transactions, min_support)
  items = FpGrowth::FpTree.get_items(transactions)
  f = FpGrowth::FpTree.new(min_support,items,transactions)
  puts "\nFrequent Itemsets\n\n"
  puts f.fp_growth
  puts "\nStrong Association Rules\n"
  puts FpGrowth::Helper.create_assoziation_rules(f.fp_growth,0.10)
end

fp(parsefile(ARGV[0]), Integer(ARGV[1]))
