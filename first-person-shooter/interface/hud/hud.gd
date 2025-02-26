extends CanvasLayer

@onready var target_label = $TargetLabel

func _ready() -> void:
	SignalBus.target_changed.connect(_on_target_changed)

func _on_target_changed(target_collider) -> void:
	if target_collider:
		target_label.set_text("{0} [{1}]".format([target_collider.name, target_collider.collision_layer]))
	else:
		target_label.set_text("")
