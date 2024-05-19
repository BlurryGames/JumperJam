class_name Utility extends Node

func addLogMessage(logString: String)-> void:
	var console: Control = get_tree().get_first_node_in_group("DebugConsole")
	if console:
		var logLabel: Label = console.find_child("LogLabel")
		if logLabel:
			if not logLabel.text.is_empty():
				logLabel.text += "\n"
			logLabel.text += logString
