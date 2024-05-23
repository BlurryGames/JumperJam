class_name ManagerIAP extends Node

signal unlockNewSkin

var googlePayment: Object = null
var newSkinSku: String = "new_player_skin"

func _ready()-> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		googlePayment = Engine.get_singleton("GodotGooglePlayBilling")
		UtilityPtr.addLogMessage("Android payment enabled")
		
		googlePayment.connected.connect(_on_connected)
		googlePayment.connect_error.connect(_on_connect_error)
		googlePayment.disconnected.connect(_on_disconnected)
		
		googlePayment.sku_details_query_completed.connect(_on_sku_details_query_completed)
		googlePayment.sku_details_query_error.connect(_on_sku_details_query_error)
		
		googlePayment.startConnection()
	else:
		UtilityPtr.addLogMessage("Android payment not available")

func purchaseSkin()-> void:
	unlockNewSkin.emit()

func _on_sku_details_query_error(responseID: int, errorMessage: String, skus: Array[String])-> void:
	UtilityPtr.addLogMessage("Sku query error, respose ID: " + str(responseID)
	+ ", message: " + str(errorMessage)
	+ "Skus: " + str(skus))

func _on_sku_details_query_completed(skus: Array)-> void:
	UtilityPtr.addLogMessage("Sku details query completed")
	for s in skus:
		UtilityPtr.addLogMessage("Sku: ")
		UtilityPtr.addLogMessage(str(s))

func _on_connect_error(responseID: int, debugMessage: String)-> void:
	UtilityPtr.addLogMessage("Conect error, response ID: " + str(responseID) + " Debug message " + debugMessage)

func _on_connected()-> void:
	UtilityPtr.addLogMessage("Connected")
	
	googlePayment.querySkuDetails([newSkinSku], "inapp")

func _on_disconnected()-> void:
	UtilityPtr.addLogMessage("Disconnected")
