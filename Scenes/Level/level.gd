extends Node2D


enum TimeOfDay {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

@onready var dayTimeText = $Labels/TimeOfTheDay
@onready var dayText = $Labels/DayText
@onready var labelsAnimPlayer = $Labels/AnimationPlayer
@onready var dayNightAnimPlayer = $Light/DayNightAnim

var state = TimeOfDay.MORNING
var dayCount: int = 0

func _ready() -> void:
	dayTimeText.text = "MORNING"
	set_day_text()
	morning_state()


func morning_state():
	dayNightAnimPlayer.play("morning")


func evening_state():
	dayNightAnimPlayer.play("evening")


func _on_day_night_timeout() -> void:
	if state < 3:
		state += 1
	else:
		state = TimeOfDay.MORNING

	match state:
		TimeOfDay.MORNING:
			dayTimeText.text = "MORNING"
			set_day_text()
			morning_state()
		TimeOfDay.DAY:
			dayTimeText.text = "DAY"
		TimeOfDay.EVENING:
			dayTimeText.text = "EVENING"
			evening_state()
		TimeOfDay.NIGHT:
			dayTimeText.text = "NIGHT"


func set_day_text():
	dayCount += 1
	dayText.text = 'Day: ' + str(dayCount)
	labelsAnimPlayer.play('dayTextVisibility')
