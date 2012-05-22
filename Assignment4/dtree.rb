require 'rubygems'
require 'ai4r'

#take attribute labels
ATTR_LABELS = ['age', 'gender', 'year-income']
#take attributes
ATTR_ITEMS = [['< 30','Male','60k - 100k'], 
	      ['< 30','Female','> 100k'],
	      ['> 60','Male','> 100k'],
	      ['> 60','Female','60k - 100k'],
	      ['30 - 60','Male','< 60k'],
	      ['30 - 60','Female','60k - 100k'],
	      ['< 30','Male','> 100k'],
	      ['< 30','Female','60k - 100k'],
	      ['> 60','Male','> 100k'],
	      ['30 - 60','Female','60k - 100k'],
	      ['< 30','Male','60k - 100k'],
	      ['< 30','Female','< 60k']]

#take class label
CLASS_LABEL = 'credit-ranking'
#take classes
CLASSES = ['Excellent',
	   'Excellent',
	   'Excellent',
	   'Excellent',
	   'Excellent',
	   'Good',
	   'Good',
	   'Good',
	   'Good',
	   'Fair',
	   'Fair',
	   'Fair',
	   'Fair']
#take counts
COUNTS = [16,
	  4,
	  16,
	  4,
	  15,
	  5,
	  15,
	  5,
	  18,
	  18,
	  2,
	  2]

table = Array.new
table_labels = (ATTR_LABELS << CLASS_LABEL)

ATTR_ITEMS.each_index  {|tuple|
	COUNTS[tuple].times {
		tmp = Array.new
	        tmp.replace(ATTR_ITEMS[tuple])
		table << (tmp << CLASSES[tuple])
	}
}

puts table.inspect

data_set = Ai4r::Data::DataSet.new(:data_items=>table, :data_labels=>table_labels)
id3 = Ai4r::Classifiers::ID3.new.build(data_set)

puts id3.get_rules
