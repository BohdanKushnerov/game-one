extends Area2D

#@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		var createdTween = get_tree().create_tween()
		createdTween.tween_property(self, 'position', position - Vector2(0, 25), 0.3)
		createdTween.tween_property(self, 'modulate:a', 0, 0.3)
		createdTween.tween_callback(queue_free)
		body.gold += 1
		
