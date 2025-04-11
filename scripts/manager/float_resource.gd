extends Resource
class_name FloatResource

var __value: float
var value: float:
	get: return __value
	set (value): assert(false, "Use set_value/use/add")

var min_value: float
var max_value: float

func _init(start_value: float, _min_value: float = 0.0, _max_value: float = INF):
	min_value = _min_value
	max_value = _max_value
	__value = min(max_value, max(min_value, start_value))

func set_value(amount: float) -> void:
	__value = amount

# use the resource
# return the amount used if there's enough of the resource
# otherwise: 
#    * if `deplete` is set, use up as much of the resource as possible
#      and return the amount used
#    * if `deplete` is not set, return false
#
func use(amount: float, deplete: bool = false) -> Variant:
	if __value >= amount:
		__value -= amount
		return amount
	if deplete:
		var used = __value
		__value = 0.0
		return used
	return false

# add a resource up to a maxium
func add(amount: float) -> float:
	var before = __value
	__value = min(max_value, before + amount)
	return __value - before

func set_min(_min_value: float):
	min_value = _min_value
	__value = max(min_value, __value)

func set_max(_max_value: float):
	max_value = _max_value
	__value = min(max_value, __value)

func get_usage() -> float:
	return inverse_lerp(min_value, max_value, __value)
