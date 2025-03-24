class_name DataSourceHelper

var _obj
var _data_source: DataSourceManager.DataSource

# 初始化辅助对象
func _init(obj):
	_obj = obj

# 绑定自身的回调函数
func bind(what: String, method_name: String) -> DataSourceManager.DataSource:
	var callback = Callable(_obj, method_name)
	_data_source = DataSourceManager.reg_data_source(_obj, what, callback)
	return _data_source

# 绑定其他对象的回调函数
func bind_other(what: String, other_obj, method_name: String) -> DataSourceManager.DataSource:
	var callback = Callable(other_obj, method_name)
	_data_source = DataSourceManager.reg_data_source(_obj, what, callback)
	return _data_source

# 获取 DataSource 对象
func get_data_source() -> DataSourceManager.DataSource:
	return _data_source
