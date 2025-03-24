extends Control
var happy_value = 0:
	set(value):
		datasource_helper.get_data_source().set_data(value)
		
var datasource_helper:DataSourceHelper

func _ready() -> void:
	datasource_helper = DataSourceHelper.new(self)
	datasource_helper.bind("happy_value", "on_happly_value_changed")
	
func on_happly_value_changed(new_value, old_value):
	$VBoxContainer/Label.text = str(new_value)
	$VBoxContainer/ProgressBar.set_value_no_signal(new_value)
	$VBoxContainer/SpinBox.set_value_no_signal(new_value)
	$VBoxContainer/HSlider.set_value_no_signal(new_value)
	
func _on_progress_bar_value_changed(value: float) -> void:
	happy_value = value
	pass # Replace with function body.


func _on_spin_box_value_changed(value: float) -> void:
	happy_value = value
	pass # Replace with function body.


func _on_h_slider_value_changed(value: float) -> void:
	happy_value = value
	pass # Replace with function body.
