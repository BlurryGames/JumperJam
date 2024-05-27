class_name ManagerIAP extends Node

signal unlock_new_skin

var google_payment: Object = null
var apple_payment: Object = null

var new_skin_sku: String = "new_player_skin"
var new_skin_token: String = ""

var apple_product_id: String = "player_new_skin"

func _ready()-> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		UtilityPtr.addLogMessage("Android payment enabled")
		
		google_payment.connected.connect(_on_connected)
		google_payment.connect_error.connect(_on_connect_error)
		google_payment.disconnected.connect(_on_disconnected)
		
		google_payment.sku_details_query_completed.connect(_on_sku_details_query_completed)
		google_payment.sku_details_query_error.connect(_on_sku_details_query_error)
		
		google_payment.purchases_updated.connect(_on_purchases_updated)
		google_payment.purchase_error.connect(_on_purchase_error)
		
		google_payment.purchase_acknowledged.connect(_on_purchase_acknowledged)
		google_payment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error)
		
		google_payment.query_purchases_response.connect(_on_query_purchases_response)
		
		google_payment.purchase_consumed.connect(_on_purchase_consumed)
		google_payment.purchase_consumption_error.connect(_on_purchase_consumption_error)
		
		google_payment.startConnection()
	else:
		UtilityPtr.addLogMessage("Android payment not available")
	
	if Engine.has_singleton("InAppStore"):
		apple_payment = Engine.get_singleton("InAppStore")
		UtilityPtr.addLogMessage("iOS IAP support is available.")
		
		var result = apple_payment.request_product_info({ "product_ids": [apple_product_id] })
		if result == OK:
			UtilityPtr.addLogMessage("Succesfully started product info request")
			apple_payment.set_auto_finish_transaction(true)
			
			var timer: Timer = Timer.new()
			timer.wait_time = 1.0
			timer.timeout.connect(check_events)
			add_child(timer)
			timer.start()
		else:
			UtilityPtr.addLogMessage("Failed to request product info")
	else:
		UtilityPtr.addLogMessage("iOS IAP support is not available.")

func _on_sku_details_query_error(response_id: int, error_message: String, skus: Array[String])-> void:
	UtilityPtr.addLogMessage("Sku query error, respose ID: " + str(response_id)
	+ ", message: " + error_message
	+ "Skus: " + str(skus))

func _on_purchase_error(response_id: int, error_message: String)-> void:
	UtilityPtr.addLogMessage("Purchase error, response ID: " + str(response_id) + " Error message: " + error_message)

func _on_purchase_acknowledgement_error(response_id: int, error_message: String, purchase_token: String)-> void:
	UtilityPtr.addLogMessage("Purchase acknowledgment error, response ID: " + str(response_id)
	+ " Error message: " + error_message
	+ " Token: " + purchase_token)

func _on_connect_error(response_id: int, debug_message: String)-> void:
	UtilityPtr.addLogMessage("Conect error, response ID: " + str(response_id) + " Debug message " + debug_message)

func _on_purchase_consumption_error(response_id: int, error_message: String, purchase_token: String)-> void:
	UtilityPtr.addLogMessage("Purchase consumption error, response ID: " + str(response_id)
	+ " Error message: " + error_message
	+ " Token: " + purchase_token)

func _on_sku_details_query_completed(skus: Array)-> void:
	UtilityPtr.addLogMessage("Sku details query completed")
	for s in skus:
		UtilityPtr.addLogMessage("Sku: ")
		UtilityPtr.addLogMessage(str(s))
	google_payment.queryPurchases("inapp")

func _on_purchases_updated(purchases: Array)-> void:
	if purchases.size() > 0:
		var purchase = purchases[0]
		var purchase_sku = purchase["skus"][0]
		UtilityPtr.addLogMessage("Purchased item with sku: " + purchase_sku)
		if purchase_sku == new_skin_sku:
			new_skin_token = purchase.purchase_token
			google_payment.acknowledgePurchase(purchase.purchase_token)

func _on_purchase_acknowledged(purchase_token: String)-> void:
	UtilityPtr.addLogMessage("Purchase acknowledged successfully!")
	if not new_skin_token.is_empty():
		if new_skin_token == purchase_token:
			UtilityPtr.addLogMessage("Unlocking new skin.")
			unlock_new_skin.emit()

func _on_query_purchases_response(query_result)-> void:
	if query_result.status == OK:
		UtilityPtr.addLogMessage("Query purchases was successful")
		var purchases = query_result.purchases
		var purchase = purchases[0]
		var purchase_sku = purchase["skus"][0]
		if new_skin_sku == purchase_sku:
			new_skin_token = purchase.purchase_token
			if not purchase.is_acknowledged:
				google_payment.acknowdlegePurchase(purchase.purchase_token)
			else:
				unlock_new_skin.emit()
				UtilityPtr.addLogMessage("Unlocking new skin because it was purchased previously.")
	else:
		UtilityPtr.addLogMessage("Query purchases failed")

func _on_purchase_consumed(purchase_token: String)-> void:
	UtilityPtr.addLogMessage("Purchase consumed successfully!")

func _on_connected()-> void:
	UtilityPtr.addLogMessage("Connected")
	
	google_payment.querySkuDetails([new_skin_sku], "inapp")

func _on_disconnected()-> void:
	UtilityPtr.addLogMessage("Disconnected")

func purchase_skin()-> void:
	if google_payment:
		var response = google_payment.purchase(new_skin_sku)
		UtilityPtr.addLogMessage("Purchase attempted, response: " + str(response.status))
		if response.status != OK:
			UtilityPtr.addLogMessage("Error purchasing skin!")
	elif apple_payment:
		var result = apple_payment.purchase({ "product_id": apple_product_id })
		if result == OK:
			UtilityPtr.addLogMessage("Purchase result is OK!")
		else:
			UtilityPtr.addLogMessage("Purchase failed!")

func reset_purchases()-> void:
	if google_payment:
		UtilityPtr.addLogMessage("Try to reset purchase")
		if not new_skin_token.is_empty():
			google_payment.consumePurchase(new_skin_token)

func check_events()-> void:
	while apple_payment.get_pending_event_count() > 0:
		var event = apple_payment.pop_pending_event()
		if event.result == "ok":
			match event.type:
				"product_info":
					UtilityPtr.addLogMessage(str(event))
				"purchase":
					if event.product_id == apple_product_id:
						unlock_new_skin.emit()
						UtilityPtr.addLogMessage("Purchased the skin IAP, unlock it!")
