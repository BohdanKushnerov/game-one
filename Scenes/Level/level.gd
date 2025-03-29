extends Node2D


enum TimeOfDay {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

@onready var light = $DirectionalLight2D
@onready var pointLight = $PointLight2D
var state = TimeOfDay.MORNING


func _ready() -> void:
	light.enabled = true


func _process(delta: float) -> void:
	match state:
		TimeOfDay.MORNING:
			morningState()
		TimeOfDay.EVENING:
			eveningState()


func morningState():
	var tween = get_tree().create_tween()
	tween.tween_property(light, 'energy', 0.2, 20)
	tween.tween_property(pointLight, 'energy', 0, 20)


func eveningState():
	var tween = get_tree().create_tween()
	tween.tween_property(light, 'energy', 0.95, 20)
	tween.tween_property(pointLight, 'energy', 1.5, 20)


func _on_day_night_timeout() -> void:
	state = TimeOfDay.values()[(state + 1) % TimeOfDay.size()]
