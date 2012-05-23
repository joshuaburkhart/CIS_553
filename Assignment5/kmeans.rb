#Usage: ruby kmeans.rb

class Cluster < Array
				attr_accessor :center_x
				attr_accessor :center_y
				attr_accessor :delta
				def initialize(x,y)
								@center_x = x
								@center_y = y
				end
				def to_s
								puts "cluster(#{@center_x},#{@center_y})"
								self.each { |item|
												puts item.to_s
								}
								puts
				end
				def find_center
								@totalx =0
								@totaly =0
								self.each { |item|
												@totalx += item.x
												@totaly += item.y
								}
								@new_center_x = @totalx / self.length
								@new_center_y = @totaly / self.length
								@delta = (@center_x - @new_center_x)**2 + (@center_y - @new_center_y)**2
								@center_x = @new_center_x
								@center_y = @new_center_y
				end
end

class Point
				attr_accessor :cluster
				attr_accessor :name
				attr_accessor :x
				attr_accessor :y
				def initialize(name,x,y,c)
								@name = name
								@x = x
								@y = y
								setCluster(c)
				end
				def to_s
								"#{@name}(#{@x},#{@y})"
				end
				def setCluster(c)
								@cluster = c
								@cluster << self
				end
end

def dist(p,c)
				((p.x - c.center_x)**2.0 + (p.y - c.center_y)**2.0)**(1.0/2.0)
end

def group(points,clstrs)
				points.each { |p|
								clstrs.each { |c|
												if dist(p,c) < dist(p,p.cluster)
																p.cluster.delete(p)
																p.setCluster(c)
												end
								}
				}
end

def print_cs(clstrs)
				puts "---------------------"
				clstrs.each { |c|
								c.to_s
				}
				puts "---------------------"
end

def center_cs(clstrs)
				clstrs.each { |c|
								c.find_center
				}
end

##########################
#DRIVER BELOW
##########################

clstrs=[Cluster.new(3.0,10.0),
				Cluster.new(5.0,8.0),
				Cluster.new(2.0,2.0)]

points=[Point.new("A1",3.0,10.0,clstrs[0]),
				Point.new("A2",3.0,5.0,clstrs[0]),
				Point.new("A3",9.0,4.0,clstrs[0]),
				Point.new("B1",5.0,8.0,clstrs[0]),
				Point.new("B2",7.0,5.0,clstrs[0]),
				Point.new("B3",6.0,4.0,clstrs[0]),
				Point.new("C1",2.0,2.0,clstrs[0]),
				Point.new("C2",5.0,9.0,clstrs[0]),
				Point.new("C3",6.0,9.0,clstrs[0])]

difference = 1
while difference > 0
				difference = 0

				group(points,clstrs)
				center_cs(clstrs)
				print_cs(clstrs)

				clstrs.each { |c|
								difference += c.delta
				}
				puts difference
end

