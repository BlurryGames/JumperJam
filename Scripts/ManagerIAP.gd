class_name ManagerIAP extends Node

signal unlockNewSkin

var googlePayment: Object = null

func _ready()-> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		googlePayment = Engine.get_singleton("GodotGooglePlayBilling")
		UtilityPtr.addLogMessage("Android payment enabled")
		
		googlePayment.connected.connect(_on_connected)
		googlePayment.connect_error.connect(_on_connect_error)
		googlePayment.disconnected.connect(_on_disconnected)
		
		googlePayment.startConnection()
	else:
		UtilityPtr.addLogMessage("Android payment not available")

func purchaseSkin()-> void:
	unlockNewSkin.emit()

func _on_connect_error(responseID: int, debugMessage: String)-> void:
	UtilityPtr.addLogMessage("Conect error, response ID: " + str(responseID) + "Debug message" + debugMessage)

func _on_connected()-> void:
	UtilityPtr.addLogMessage("Connected")

func _on_disconnected()-> void:
	UtilityPtr.addLogMessage("Disconnected")
