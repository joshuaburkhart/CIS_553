#Usage: ruby wig_merge.rb <reference filename> <auxillary filename 1> <auxillary filename 2>
#Example: ruby wig_merge.rb ESX0000001760.wig ESX0000001748.wig ESX0000003301.wig

ref_filename = ARGV[0]
print "\t#{ref_filename}\t"

aux_files = Array.new
aux_l_buf = Array.new
(1..ARGV.length - 1).each do |i|
	print "#{ARGV[i]}\t"
	aux_files << File.new(ARGV[i])
	aux_l_buf << "track"
end
puts

def valid(line,limit)
	within_limit = false
	if(line.match(/^chr.*?-.*?[' ']/))
		line_pos = line.match(/^chr.*?-(.*?)[' '].*$/)[1]
		within_limit = (Integer(line_pos) <= Integer(limit))
		#puts "line_pos: #{line_pos}, limit: #{limit}, within_limit: #{within_limit}"
	end
	return line.match(/^track/) || line.match(/^variableStep/) || within_limit
end

File.open(ref_filename,'r') do |ref_file|
	while ref_line = ref_file.gets
		ref_chrm = "default"
		ref_start = -1
		ref_label = "no-label"
		values = Array.new
		if(ref_line.match(/^track/))
			#print ref_line
		elsif(ref_line.match(/^variableStep/))
			#print ref_line
		elsif(ref_line.match(/^chr.*?-.*?[' '].*?$/))
			ref_chrm = ref_line.match(/^(chr.*?)-.*$/)[1]
			ref_start = ref_line.match(/^chr.*?-(.*?)[' '].*$/)[1]
			ref_label = ref_line.match(/^(chr.*?-.*?)[' ']/)[1]
			values << ref_line.match(/^chr.*?-.*?[' '](.*)$/)[1]
			aux_files.each_index do |i|
				while (cur_line=aux_l_buf[i]) && (valid(cur_line,ref_start))
					if(cur_line.match(/^chr.*?-.*?[' '].*?$/))
						aux_label = cur_line.match(/^(chr.*?-.*?)[' ']/)[1]
						#puts "aux_label: #{aux_label}"
						if(aux_label == ref_label)
							values << cur_line.match(/^chr.*?-.*?[' '](.*)$/)[1]
						end
					end
					aux_l_buf[i] = aux_files[i].gets
				end
			end

			if(values.length == (aux_files.length + 1))
				print "#{ref_label}\t"
				values.each do |i|
					print "#{i}\t"
				end
				puts
			end
		end		
	end
end

aux_files.each do |aux_file|
	aux_file.close
end

