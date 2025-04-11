extends Node

func grid_interpolate(from: Vector3i, to: Vector3i) -> Array[Vector3i]:
	var pixels: Array[Vector3i] = [from]
	
	var p = Vector3(from)
	var diff = to - from
	var abs_diff = abs(diff)
	var steps = abs_diff[abs_diff.max_axis_index()]
	
	if steps:
		var increment = Vector3(diff) / float(steps)
		
		while Vector3i(p) != to:
			p += increment
			pixels.append(Vector3i(p))
	
	return pixels
