#Usage: ruby explicit_position.rb <filename>
#Example: ruby explicit_position.rb ESX0000001760.wig

filename = ARGV[0]
File.open(filename,'r') do |file|
	chrm_label = "default"
	while line = file.gets
		if(line.match(/^track/))
			print line
		elsif(line.match(/^variableStep/))
			print line
			chrm_label = line.match(/chrom=(.*?)[' ']/)[1]
		elsif(line.match(/^[0-9]/))
			print "#{chrm_label}-#{line}"
		end
	end
end

