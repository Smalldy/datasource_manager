extends Node
class DataSource:
	var _data
	var _old_data
	var _on_data_changed_list: Array[Callable] = []

	# 设置数据并通知所有订阅者
	func set_data(data):
		_old_data = _data
		_data = data
		_notify_data_changed()

	# 获取当前数据
	func get_data():
		return _data

	# 订阅数据变化回调
	func subscribe_data(on_data_changed: Callable):
		if not _on_data_changed_list.has(on_data_changed):
			_on_data_changed_list.append(on_data_changed)

	# 取消订阅数据变化回调
	func unsubscribe_data(on_data_changed: Callable):
		var find_index = _on_data_changed_list.find(on_data_changed)
		if find_index != -1:
			_on_data_changed_list.remove_at(find_index)

	# 通知所有订阅者数据变化
	func _notify_data_changed():
		for callback in _on_data_changed_list:
			callback.call(_data, _old_data)

# 用于存储所有注册的 DataSource 对象
var _data_sources: Dictionary = {}

# 注册 DataSource 并返回 DataSource 对象
func reg_data_source(obj, what: String, on_changed: Callable) -> DataSource:
	var key = _get_data_source_key(obj, what)
	if not _data_sources.has(key):
		_data_sources[key] = DataSource.new()
	if on_changed.is_valid():
		_data_sources[key].subscribe_data(on_changed)
	return _data_sources[key]

# 查询已注册的 DataSource 对象
func get_data_source(obj, what: String) -> DataSource:
	var key = _get_data_source_key(obj, what)
	if _data_sources.has(key):
		return _data_sources[key]
	return null

# 取消注册 DataSource（粒度1：取消对象的所有 DataSource）
func unreg_data_source_v1(obj):
	var keys_to_remove = []
	for key in _data_sources.keys():
		if key.begins_with(str(obj.get_instance_id())):
			keys_to_remove.append(key)
	for key in keys_to_remove:
		_data_sources.erase(key)

# 取消注册 DataSource（粒度2：取消对象的某个属性的所有 DataSource）
func unreg_data_source_v2(obj, what: String):
	var key = _get_data_source_key(obj, what)
	if _data_sources.has(key):
		_data_sources.erase(key)

# 取消注册 DataSource（粒度3：取消对象的某个属性的某个回调）
func unreg_data_source_v3(obj, what: String, on_changed: Callable):
	var key = _get_data_source_key(obj, what)
	if _data_sources.has(key):
		_data_sources[key].unsubscribe_data(on_changed)
		if _data_sources[key]._on_data_changed_list.is_empty():
			_data_sources.erase(key)

# 辅助函数：生成 DataSource 的键
func _get_data_source_key(obj, what: String) -> String:
	return "%s:%s" % [obj.get_instance_id(), what]
