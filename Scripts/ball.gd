extends Sprite2D

@export var Colors : PackedColorArray

func _ready():
	var rng = RandomNumberGenerator.new()
	modulate = Colors[rng.randi_range(0, Colors.size() - 1)]
