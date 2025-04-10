extends Resource
class_name FloatResource

var __value: float
var value: float:
	get: return __value
	set (value): assert(false, "Use value_set/use/add")

func _init(start_value: float):
	__value = start_value

func value_set(amount: float) -> void:
	__value = amount

func use(amount: float, deplete: bool = false) -> bool:
	if __value >= amount:
		__value -= amount
		return true
	if deplete:
		__value = 0.0
	return false

func add(amount: float):
	__value += amount
