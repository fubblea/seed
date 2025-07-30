extends CanvasLayer

signal slider_value_changed(water: float, sunlight: float)

var water_level: float = 50.0
var sunlight_level: float = 50.0

@onready var water_slider: HSlider = $"Water/WaterSlider"
@onready var sunlight_slider: HSlider = $"Sunlight/SunlightSlider"

@onready var help_text: RichTextLabel = $HelpText
@onready var timer_text: Label = $"TimerText"
@onready var final_text: Label = $"FinalText"

@onready var plant_growth_bar: ProgressBar = $"PlantGrowth"

func _ready() -> void:
	water_slider.value = water_level
	sunlight_slider.value = sunlight_level

	final_text.visible = false

	emit_signal("slider_value_changed", water_level, sunlight_level)

func update_help_text(water: bool, sunlight: bool) -> void:
	if not help_text:
		return

	help_text.text = "Water Good?: %s\nSunlight Good?: %s" % [
		str(water),
		str(sunlight)
	]

func _on_water_slider_value_changed(value: float) -> void:
	water_level = value
	emit_signal("slider_value_changed", water_level, sunlight_level)

func _on_sunlight_slider_value_changed(value: float) -> void:
	sunlight_level = value
	emit_signal("slider_value_changed", water_level, sunlight_level)
