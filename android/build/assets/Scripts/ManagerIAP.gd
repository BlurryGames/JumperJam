class_name ManagerIAP extends Node

signal unlockNewSkin

var googlePayment = null

func _ready()-> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		googlePayment = Engine.get_singleton("GodotGooglePlayBilling")
		UtilityPtr.addLogMessage("Android payment enabled")
	else:
		UtilityPtr.addLogMessage("Android payment not available")

func purchaseSkin()-> void:
	unlockNewSkin.emit()
