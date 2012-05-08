def normalize()

	applicant_vals = [61,68,69,71,76,79,81,83,85,85,85,86,86,87,87,88,88,89,90,93,95,95,96,98]

	applicant_vals.each do |score|
		puts gpa_norm(score)
	end
end

def gpa_norm(v)
	minA=60.0
	maxA=95.0
	new_maxA=4.3
	new_minA=1.0
	vp = ((v - minA) / (maxA - minA)) * (new_maxA - new_minA) + new_minA
	vp = vp < 1.0 ? 1.0 : vp
        vp = vp > 4.3 ? 4.3 : vp	
	return vp
end

normalize()
