@tool
extends Node

class_name GameState

signal timer_value_changed(time_left: float)

const GAME_TIME_LIMIT: float = 120.0

var water_level: float
var sunlight_level: float

@onready var water_spray: Node2D = $"../WaterSpray"
@onready var sun_light: Node2D = $"../SunLight"
@onready var main_ui: Node = $"../MainUI"
@onready var timer = $"GameTimer"

func _ready() -> void:
	timer.wait_time = GAME_TIME_LIMIT
	timer.start()

	update_opacity()

func _process(_delta: float) -> void:
	if timer.time_left <= 0:
		# TODO: Handle game over logic here
		print("Game Over! Time's up!")
		get_tree().quit()
	else:
		emit_signal("timer_value_changed", timer.time_left)

func _on_main_ui_slider_value_changed(water: float, sunlight: float) -> void:
	water_level = water
	sunlight_level = sunlight
	update_opacity()

func update_opacity() -> void:
	water_spray.modulate.a = clamp(water_level / 100, 0.0, 1.0)
	sun_light.modulate.a = clamp(sunlight_level / 100, 0.0, 1.0)
