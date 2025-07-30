extends CanvasLayer

signal slider_value_changed(water: float, sunlight: float)

var water_level: float = 50.0
var sunlight_level: float = 50.0

@onready var water_slider: HSlider = $"Water/WaterSlider"
@onready var sunlight_slider: HSlider = $"Sunlight/SunlightSlider"

@onready var help_text: RichTextLabel = $HelpText
@onready var timer_text: Label = $"TimerText"

func _ready() -> void:
	water_slider.value = water_level
	sunlight_slider.value = sunlight_level

	_update_help_text(water_level, sunlight_level)
	emit_signal("slider_value_changed", water_level, sunlight_level)

func _update_help_text(water: float, sunlight: float) -> void:
	help_text.text = "Water Level: %s\nSunlight Level: %s" % [
		str(water),
		str(sunlight)
	]

func _on_water_slider_value_changed(value: float) -> void:
	water_level = value
	_update_help_text(water_level, sunlight_level)
	emit_signal("slider_value_changed", water_level, sunlight_level)

func _on_sunlight_slider_value_changed(value: float) -> void:
	sunlight_level = value
	_update_help_text(water_level, sunlight_level)
	emit_signal("slider_value_changed", water_level, sunlight_level)


func _on_game_state_timer_value_changed(time_left: float) -> void:
	timer_text.text = str(int(time_left))
