extends Node2D

func _ready() -> void:
	Game.win.connect(play_win)

func play_win() -> void:
	$AnimationPlayer.play("win")
	$CPUParticles2D.restart()
