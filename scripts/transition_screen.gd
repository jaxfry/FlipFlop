extends CanvasLayer

signal on_transition_finished

@onready var color_rec = $ColorRect
@onready var animation_player = $AnimationPlayer

var _next_scene_path: String = ""

func _ready():
	color_rec.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		if _next_scene_path != "":
			get_tree().change_scene_to_file(_next_scene_path)
			_next_scene_path = ""
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rec.visible = false

func transition():
	color_rec.visible = true
	animation_player.play("fade_to_black")

func change_scene(path: String):
	_next_scene_path = path
	transition()
