extends SubViewport

func _ready():
	get_tree().root.size_changed.connect(update_size)
	update_size()
	

func update_size():
	size = get_tree().root.size
