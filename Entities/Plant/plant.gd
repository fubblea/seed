extends Node2D


@onready var animated_sprite: AnimatedSprite2D = $"AnimatedSprite2D"

func update_plant_health(health: float) -> void:
	var red_intensity = clamp(1.0 - health, 0.0, 1.0)
	animated_sprite.modulate = Color(1.0, 1.0 - red_intensity, 1.0 - red_intensity)
