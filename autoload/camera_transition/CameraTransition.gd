extends Node2D

var is_transitioning = false
onready var camera2D = $Camera2D
onready var camera3D = $Camera
onready var tween = $Tween

func transition_camera3D(from: Camera, to: Camera, duration: float = 1.0) -> void:
		if is_transitioning: return
		
		camera3D.fov = from.fov
		camera3D.cull_mask = from.cull_mask
		camera3D.global_transform = from.global_transform
		
		camera3D.current = true
		
		is_transitioning = true
		
		tween.remove_all()
		tween.interpolate_property(camera3D, "global_transform", camera3D.global_transform,
			to.global_transform, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(camera3D, "fov", camera3D.fov,
			to.fov, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		to.current = true
		is_transitioning = false

func transition_camera2D(from: Camera2D, to: Camera2D, duration: float = 1.0) -> void:
		if is_transitioning: return
		
		camera2D.zoom = from.zoom
		camera2D.offset = from.offset
		camera2D.light_mask = from.light_mask
		
		camera2D.global_transform = from.global_transform
		
		camera2D.current = true
		is_transitioning = true
		
		tween.remove_all()
		tween.interpolate_property(camera2D, "global_transform", camera2D.global_transform,
			to.global_transform, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(camera2D, "zoom", camera2D.zoom,
			to.zoom, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(camera2D, "offset", camera2D.offset,
			to.offset, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		to.current = true
		is_transitioning = false
