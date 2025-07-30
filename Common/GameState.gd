@tool
extends Node

class_name GameState


const GAME_TIME_LIMIT: float = 120
const NEW_IDEAL_TIME: float = 5
const PLANT_GROWTH_RATE: float = 0.05
const PLANT_DECAY_RATE: float = 0.01

var water_level: float
var sunlight_level: float
var plant_growth: float = 50

var ideal_water: Array[float]
var ideal_sunlight: Array[float]

@onready var water_spray: Node2D = $"../WaterSpray"
@onready var sun_light: Node2D = $"../SunLight"
@onready var main_ui: CanvasLayer = $"../MainUI"
@onready var game_timer = $"GameTimer"
@onready var new_ideal_timer = $"NewIdealTimer"
@onready var end_game_timer = $"EndGameTimer"
@onready var plant = $"../Plant"

func _ready() -> void:
	ideal_water = get_ideal_range()
	ideal_sunlight = get_ideal_range()

	game_timer.wait_time = GAME_TIME_LIMIT
	game_timer.one_shot = true
	game_timer.start()

	new_ideal_timer.wait_time = NEW_IDEAL_TIME
	new_ideal_timer.one_shot = true
	new_ideal_timer.start()

	end_game_timer.wait_time = 3
	end_game_timer.one_shot = true

	update_opacity()
	main_ui.update_help_text(
		is_plant_healthy()[0],
		is_plant_healthy()[1]
	)

func _process(_delta: float) -> void:
	if not game_timer:
		return

	if not end_game_timer or end_game_timer.time_left > 0:
		return

	if plant_growth > 100:
		game_timer.stop()

		main_ui.final_text.text = "WON!!!"
		main_ui.final_text.visible = true

		plant.animated_sprite.play("grown")
		return

	if game_timer.time_left <= 0:
		# TODO: Handle game over logic here
		print("Game Over! Time's up!")

		main_ui.final_text.text = "GAME OVER"
		main_ui.final_text.visible = true

		end_game_timer.start()
	else:
		var timer_label = main_ui.get_node("TimerText")
		timer_label.text = str(int(game_timer.time_left))
		calc_plant_state()
		main_ui.update_help_text(
			is_plant_healthy()[0],
			is_plant_healthy()[1],
		)
		plant.update_plant_health(plant_growth)

		if main_ui.plant_growth_bar:
			main_ui.plant_growth_bar.value = plant_growth

func _on_main_ui_slider_value_changed(water: float, sunlight: float) -> void:
	water_level = water
	sunlight_level = sunlight
	update_opacity()

func update_opacity() -> void:
	water_spray.modulate.a = clamp(water_level / 100, 0.0, 1.0)
	sun_light.modulate.a = clamp(sunlight_level / 100, 0.0, 1.0)

func get_ideal_range() -> Array[float]:
	var min_val = randi_range(20, 100)
	return [min_val, min_val + randi_range(0, 100 - min_val)]

func is_plant_healthy() -> Array[bool]:
	return [(water_level >= ideal_water[0] and water_level <= ideal_water[1]), (sunlight_level >= ideal_sunlight[0] and sunlight_level <= ideal_sunlight[1])]

func calc_plant_state() -> void:
	if not is_plant_healthy()[0] or not is_plant_healthy()[1]:
		plant_growth -= PLANT_DECAY_RATE
		if plant_growth < 0:
			plant_growth = 0
	else:
		plant_growth += PLANT_GROWTH_RATE

func _on_new_ideal_timer_timeout() -> void:
	ideal_water = get_ideal_range()
	ideal_sunlight = get_ideal_range()

	new_ideal_timer.start()


func _on_end_game_timer_timeout() -> void:
	get_tree().reload_current_scene()
