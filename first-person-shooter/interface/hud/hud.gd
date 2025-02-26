extends CanvasLayer

@onready var target_label = $TargetLabel

func _ready() -> void:
	SignalBus.target_changed.connect(_on_target_changed)

func _on_target_changed(target_name) -> void:
	target_label.set_text(target_name)
