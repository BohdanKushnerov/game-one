extends Timer


var goldCoin = preload("res://Scenes/Collectables/Gold/coin.tscn")

func _on_timeout() -> void:
	var goldTemp = goldCoin.instantiate()
	var randomInd = randi_range(30, 300)
	goldTemp.position = Vector2(randomInd, 595)
	add_child(goldTemp)
