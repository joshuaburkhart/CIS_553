#Usage: ruby binary_filter.rb <file to be filtered> <filter file>
#Example: ruby binary_filter.rb merged.wig.explicit healthy.wig.explicit

MAX_VAL = 1.0
MIN_VAL = 0.0

# monkey patch onto strings

merged = File.open(ARGV[0])
filter = File.open(ARGV[1])

aux_l_buf << "track"

while(filter_line = filter.readline)
	#print line if track or validation
	if(ref_line.match(/^track/))
		print ref_line
	elsif(ref_line.match(/^variableStep/))
		print ref_line
	elsif(filter_line.match(/^chr.*?-.*$/))
		#f_chrom = filter_line.get_chromosome
		#f_coord = filter_line.get_coordinate
		#f_label = filter_line.get_label
		#f_value = filter_line.get_value

		while((cur_line = aux_l_buf) && (valid(cur_line,last_ref,ref_chrm,ref_start)))
			if(cur_line.match(/^#{f_label}.*$/))
				m_values = cur_line.match(/^#{f_label}[' '](.*)$/)
				if(m_values.max < f_value)
					puts "#{filter_line.get_coordinate} #{MAX_VAL}"
				elsif(m_values.min > f_value)
					puts "#{filter_line.get_coordinate} #{MIN_VAL}"
					break
				end 
				aux_l_buf = merged.gets
			end

		end

	end
end

merged.close
filter.close

