#Usage: ruby fp.rb <filename> <minimum support count> <minimum confidence>
#
#Example: ruby fp.rb ~/tmp/FoodMart.xls 5 .70

require 'rubygems'
require 'fp_growth'
require 'parseexcel'

class Hash
  def to_s
    "{#{fetch(:left)}} => {#{fetch(:right)}} support: #{fetch(:support)}, confidence: #{fetch(:confidence)}"
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

def fp(transactions, min_support, min_confidence)
  items = FpGrowth::FpTree.get_items(transactions)
  f = FpGrowth::FpTree.new(min_support,items,transactions)
  puts FpGrowth::Helper.create_assoziation_rules(f.fp_growth,min_confidence).sort { |rule_1,rule_2|
    rule_1.fetch(:confidence) <=> rule_2.fetch(:confidence)
  }
end

fp(parsefile(ARGV[0]), Integer(ARGV[1]), Float(ARGV[2]))
