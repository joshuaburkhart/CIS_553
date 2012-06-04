#Usage: ruby coord_dnsty_clstr.rb <wig file with binary values>
#Example: ruby coord_dnsty_clstr.rb filter_min.wig

class String
	def get_chromosome
		self.match(/^.*chrom=(.*?)[\s].*$/)[1]
	end
	def get_coordinate
		Integer(self.match(/^([0-9].*?)[\s].*$/)[1])
	end
	def get_value
		Float("%f" % self.match(/^[0-9].*?[\s]+([0-9]+['.'][0-9]+).*$/)[1])
	end
	def get_step
		Integer(self.match(/^.*span=([0-9]+).*$/)[1])
	end
end

class Cluster < Array
	attr_accessor :oid
	def initialize(oid)
		@oid = oid
	end
	def to_s
		puts "cluster(#{@oid}):"
		self.each { |item|
			puts item.to_s
		}
		puts
	end
	def order
		self.sort {|i,j| i.coord <=> j.coord}
	end 
	def max 
		self.order.last.coord
	end 
	def min 
		self.order.first.coord
	end 
end

class Point
	attr_accessor :cluster
	attr_accessor :name
	attr_accessor :coord
	attr_accessor :visited
	attr_accessor :noise
	def initialize(line,chrm)
		@name = line.strip
		@chrm = chrm
		@coord = name.get_coordinate
		@visited = false
		@noise = false
	end
	def to_s
		"#{@name} {chrm=#{@chrm}, visited=#{@visited}, noise=#{@noise}, cluster=#{@cluster.nil? ? -1 : @cluster.oid}}"
	end
	def setCluster(c)
		@noise = false
		@cluster = c
		@cluster << self
	end
end

def dist(p1,p2)
	((Integer(p1.coord) - Integer(p2.coord))**2.0)**(1.0/2.0)
end

def print_cs(clstrs)
	puts "---------------------"
	clstrs.each { |c|
		c.to_s
	}
	puts "---------------------"
end

##########################
#DRIVER BELOW
##########################

#experimental values obtained by quantifying leukemia methylation around chr16 796982-1734187
epsilon = 482400 # 10000 for test data
mnpts = 1224885 # 3 for test data

VAL = 1.0


file = File.open(ARGV[0])
file_line = file.gets
while(file_line)
	#print line if track or validation
	if(file_line.match(/^track/))
		print file_line
		file_line = file.gets
	elsif(file_line.match(/^variableStep/))
		print file_line
		step = file_line.get_step
		chrm = file_line.get_chromosome
		file_line = file.gets
		pts = Array.new
		while(file_line && file_line.match(/^[0-9].*?[\s].*$/))
			if(file_line.get_value == VAL)
				pts << Point.new(file_line,chrm)
			end
			file_line = file.gets
		end
		clstrs = Array.new

		visit_count = 0
		cluster_id = 0

		pts.each { |p1|
			if !p1.visited
				p1.visited = true
				visit_count +=1
				neighborhood = Array.new	
				neighborhood << p1
				pts.each {|p2|
					if p1 != p2
						if dist(p1,p2) < epsilon
							neighborhood << p2
						end
					end
				}
				if neighborhood.length >= mnpts
					p1.setCluster(Cluster.new(cluster_id))
					cluster_id +=1
					neighborhood.each {|p2|
						if !p2.visited
							p2.visited = true
							visit_count +=1
							neighborhood2 = Array.new
							neighborhood2 << p2
							pts.each {|p3|
								if p2 != p3
									if dist(p2,p3) < epsilon
										neighborhood2 << p3
									end
								end
							}
							if neighborhood2.length >= mnpts
								neighborhood.concat(neighborhood2)
							end
						end
						if p2.cluster.nil?
							p2.setCluster(p1.cluster)
						end
					}
					clstrs << p1.cluster
				else
					p1.noise = true
				end
				if visit_count >= pts.length
					break
				end
			end
		}
		#print_cs(clstrs)
		#puts "#####################"
		#puts "Noisy Points:"
		#pts.each { |p|
		#	if p.noise == true
		#		puts p
		#	end
		#}
		#puts "#####################"

		clstrs.each { |c|
			(c.min..c.max).step(step) do |i|
				puts "#{i} #{VAL}"
			end
		}
	end
end



file.close
