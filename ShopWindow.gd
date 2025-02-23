extends Control

@onready var UnitWindow = $UnitWindow

func _on_show_units_button_pressed() -> void:
	if UnitWindow.visible:
		UnitWindow.hide()
	else:
		UnitWindow.popup_centered()
		populate_units()

# This function populates the grid with buttons for each available unit
func populate_units():
	var units = [
		{"name": "Infantry", "cost": 100, "icon": preload("res://icons/icon.png")},
		{"name": "Tank", "cost": 300, "icon": preload("res://icons/icon.png")},
		{"name": "Artillery", "cost": 200, "icon": preload("res://icons/icon.png")}
	]
	
	var grid = $UnitWindow/GridContainer
	# Clear any existing children (if needed)
	for child in grid.get_children():
		child.queue_free()
	
	for unit in units:
		var btn = Button.new()
		btn.text = unit.name + " - $" + str(unit.cost)
		btn.pressed.connect(Callable(self, "_on_unit_selected").bind(unit))
		grid.add_child(btn)

func _on_unit_selected(unit):
	print("Unit selected: " + unit.name)
	# Insert your logic here to deduct currency, spawn a unit, or enter placement mode.
