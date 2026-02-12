@tool
extends Control

func _process(delta: float) -> void:
	if randi_range(5000, 1) == 1:
		$VideoStreamPlayer.show()
		$VideoStreamPlayer.play()
		await $VideoStreamPlayer.finished
		$VideoStreamPlayer.hide()
