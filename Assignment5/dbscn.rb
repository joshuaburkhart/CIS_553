#Usage: ruby dbscan.rb

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
end

class Point
	attr_accessor :cluster
	attr_accessor :name
	attr_accessor :x
	attr_accessor :y
	attr_accessor :visited
	attr_accessor :noise
	def initialize(name,x,y)
		@name = name
		@x = x
		@y = y
		@visited = false
		@noise = false
	end
	def to_s
		"#{@name}(#{@x},#{@y})-visited=#{@visited}-noise=#{@noise}-cluster=#{@cluster.nil? ? -1 : @cluster.oid}"
	end
	def setCluster(c)
		@noise = false
		@cluster = c
		@cluster << self
	end
end

def dist(p1,p2)
	((p1.x - p2.x)**2.0 + (p1.y - p2.y)**2.0)**(1.0/2.0)
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

epsilon = 3
mnpts = 3

pts=[Point.new("A1",3.0,10.0),
	Point.new("A2",3.0,5.0),
	Point.new("A3",9.0,4.0),
	Point.new("B1",5.0,8.0),
	Point.new("B2",7.0,5.0),
	Point.new("B3",6.0,4.0),
	Point.new("C1",2.0,2.0),
	Point.new("C2",5.0,9.0),
	Point.new("C3",6.0,9.0)]

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
print_cs(clstrs)
puts "#####################"
puts "Noisy Points:"
pts.each { |p|
	if p.noise == true
		puts p
	end
}
puts "#####################"

