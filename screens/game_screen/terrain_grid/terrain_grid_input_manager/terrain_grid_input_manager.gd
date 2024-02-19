class_name TerrainGridInputManager extends InputManager

signal up_exit_input_received
signal left_exit_input_received

var test_color_rect : ColorRect = ColorRect.new()

@onready var input_controller : TerrainGridController = $TerrainGridController as TerrainGridController

func _ready():
	managed_scene = get_child(0) as TerrainGrid

func set_input_controller():
	for cell in managed_scene.get_children() as Array[Cell]:
		if cell is Cell:
			if not focusable_objects.has(cell):
				focusable_objects.append(cell)
				cell.focus_entered.connect(_on_focusable_object_focus_entered.bind(cell))
				cell.focus_exited.connect(_on_focusable_object_focus_exited.bind(cell))
			
	initial_focused_object = focusable_objects[0]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _on_focusable_object_focus_entered(focused_object:Control):
	focused_object.add_child(test_color_rect)
	test_color_rect.size = focused_object.size
	test_color_rect.color = Color(0,0,1)

func _on_focusable_object_focus_exited(unfocused_object:Control):
	unfocused_object.remove_child(test_color_rect)

func on_up_exit_input_received():
	up_exit_input_received.emit()

func on_left_exit_input_received():
	left_exit_input_received.emit()

