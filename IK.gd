extends Node2D

onready var lines = $"%Line2D"

export var segments := 4
export var segment_length := 80
export var speed := 10.0

var target_location : Vector2

func _ready():
	NetworkedMultiplayerENet
	randomize()
	var points = PoolVector2Array()
	var w = ProjectSettings.get("display/window/size/width")
	var h = ProjectSettings.get("display/window/size/height")
	print_debug(w,h)
	var v = Vector2(w/2,h)
	var random_vector = Vector2(0,1) * segment_length
	points.append(v)
	for i in segments:
		random_vector = random_vector.rotated(
			deg2rad(
				rand_range(-360,360)
			)
		)
		var t = points[lines.points.size() - 1] + random_vector
		points.append(
			t
		)
	lines.points = points
	

	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		var e := event as InputEventMouseButton
		if e.pressed and e.button_index == BUTTON_LEFT:
			var t = e.position
			var tween := create_tween().parallel()
			tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
			tween.tween_property(
				self,
				"target_location",
				t,
				speed
			)
			

func _process(delta):
	var current_points = lines.points
	var t : Vector2 =  self.target_location#get_local_mouse_position()
	var points = PoolVector2Array()
	points.append(t)
	var i = 1
	var l = current_points.size()
	while i < l:
		var v : Vector2  = t - current_points[i]
		v = v.normalized() * segment_length
		v = t - v
		points.append(v)
		t = v
		i += 1
	lines.points = points			

