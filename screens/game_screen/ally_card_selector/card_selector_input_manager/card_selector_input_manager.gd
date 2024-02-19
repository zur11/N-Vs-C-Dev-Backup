class_name CardSelectorInputManager extends InputManager

signal up_exit_input_received
signal right_exit_input_received

@onready var input_controller : CardSelectorController = $CardSelectorController as CardSelectorController

func _ready():
	managed_scene = get_child(0) as AllyCardSelector

func set_input_controller():
	for card in managed_scene.get_children() as Array[AllyCard]:
		if not focusable_objects.has(card):
			focusable_objects.append(card)
			card.focus_entered.connect(_on_focusable_object_focus_entered.bind(card))
			card.focus_exited.connect(_on_focusable_object_focus_exited.bind(card))
			

	
	initial_focused_object = focusable_objects[0]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller


func _on_focusable_object_focus_entered(focused_object:Control):
	focused_object.modulate = Color(1,0,0)

func _on_focusable_object_focus_exited(unfocused_object:Control):
	unfocused_object.modulate = Color(1,1,1)

func on_up_exit_input_received():
	up_exit_input_received.emit()

func on_right_exit_input_received():
	right_exit_input_received.emit()
