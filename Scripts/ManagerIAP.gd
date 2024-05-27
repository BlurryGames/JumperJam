class_name ManagerIAP extends Node

signal unlockNewSkin

var googlePayment: Object = null
var apple_payment: Object = null
var newSkinSku: String = "new_player_skin"
var newSkinToken: String = ""

func _ready()-> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		googlePayment = Engine.get_singleton("GodotGooglePlayBilling")
		UtilityPtr.addLogMessage("Android payment enabled")
		
		googlePayment.connected.connect(_on_connected)
		googlePayment.connect_error.connect(_on_connect_error)
		googlePayment.disconnected.connect(_on_disconnected)
		
		googlePayment.sku_details_query_completed.connect(_on_sku_details_query_completed)
		googlePayment.sku_details_query_error.connect(_on_sku_details_query_error)
		
		googlePayment.purchases_updated.connect(_on_purchases_updated)
		googlePayment.purchase_error.connect(_on_purchase_error)
		
		googlePayment.purchase_acknowledged.connect(_on_purchase_acknowledged)
		googlePayment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error)
		
		googlePayment.query_purchases_response.connect(_on_query_purchases_response)
		
		googlePayment.purchase_consumed.connect(_on_purchase_consumed)
		googlePayment.purchase_consumption_error.connect(_on_purchase_consumption_error)
		
		googlePayment.startConnection()
	else:
		UtilityPtr.addLogMessage("Android payment not available")
	
	if Engine.has_singleton("InAppStore"):
		apple_payment = Engine.get_singleton("InAppStore")
		UtilityPtr.addLogMessage("iOS IAP support is available.")
		
		var result = apple_payment.request_product_info({ "product_ids": [apple_product_id] })
		if result == OK:
			UtilityPtr.addLogMessage("Succesfully started product info request")
			
			var timer: Timer = Timer.new()
			timer.wait_time = 1.0
			timer.timeout.connect(check_events)
			add_child(timer)
			timer.start()
		else:
			UtilityPtr.addLogMessage("Failed to request product info")
	else:
		UtilityPtr.addLogMessage("iOS IAP support is not available.")

func _on_sku_details_query_error(responseID: int, errorMessage: String, skus: Array[String])-> void:
	UtilityPtr.addLogMessage("Sku query error, respose ID: " + str(responseID)
	+ ", message: " + errorMessage
	+ "Skus: " + str(skus))

func _on_purchase_error(responseID: int, errorMessage: String)-> void:
	UtilityPtr.addLogMessage("Purchase error, response ID: " + str(responseID) + " Error message: " + errorMessage)

func _on_purchase_acknowledgement_error(responseID: int, errorMessage: String, purchaseToken: String)-> void:
	UtilityPtr.addLogMessage("Purchase acknowledgment error, response ID: " + str(responseID)
	+ " Error message: " + errorMessage
	+ " Token: " + purchaseToken)

func _on_connect_error(responseID: int, debugMessage: String)-> void:
	UtilityPtr.addLogMessage("Conect error, response ID: " + str(responseID) + " Debug message " + debugMessage)

func _on_purchase_consumption_error(responseID: int, errorMessage: String, purchaseToken: String)-> void:
	UtilityPtr.addLogMessage("Purchase consumption error, response ID: " + str(responseID)
	+ " Error message: " + errorMessage
	+ " Token: " + purchaseToken)

func _on_sku_details_query_completed(skus: Array)-> void:
	UtilityPtr.addLogMessage("Sku details query completed")
	for s in skus:
		UtilityPtr.addLogMessage("Sku: ")
		UtilityPtr.addLogMessage(str(s))
	googlePayment.queryPurchases("inapp")

func _on_purchases_updated(purchases: Array)-> void:
	if purchases.size() > 0:
		var purchase = purchases[0]
		var purchaseSku = purchase["skus"][0]
		UtilityPtr.addLogMessage("Purchased item with sku: " + purchaseSku)
		if purchaseSku == newSkinSku:
			newSkinToken = purchase.purchase_token
			googlePayment.acknowledgePurchase(purchase.purchase_token)

func _on_purchase_acknowledged(purchaseToken: String)-> void:
	UtilityPtr.addLogMessage("Purchase acknowledged successfully!")
	if not newSkinToken.is_empty():
		if newSkinToken == purchaseToken:
			UtilityPtr.addLogMessage("Unlocking new skin.")
			unlockNewSkin.emit()

func _on_query_purchases_response(queryResult)-> void:
	if queryResult.status == OK:
		UtilityPtr.addLogMessage("Query purchases was successful")
		var purchases = queryResult.purchases
		var purchase = purchases[0]
		var purchaseSku = purchase["skus"][0]
		if newSkinSku == purchaseSku:
			newSkinToken = purchase.purchase_token
			if not purchase.is_acknowledged:
				googlePayment.acknowdlegePurchase(purchase.purchase_token)
			else:
				unlockNewSkin.emit()
				UtilityPtr.addLogMessage("Unlocking new skin because it was purchased previously.")
	else:
		UtilityPtr.addLogMessage("Query purchases failed")

func _on_purchase_consumed(purchaseToken: String)-> void:
	UtilityPtr.addLogMessage("Purchase consumed successfully!")

func _on_connected()-> void:
	UtilityPtr.addLogMessage("Connected")
	
	googlePayment.querySkuDetails([newSkinSku], "inapp")

func _on_disconnected()-> void:
	UtilityPtr.addLogMessage("Disconnected")

func purchaseSkin()-> void:
	if googlePayment:
		var response = googlePayment.purchase(newSkinSku)
		UtilityPtr.addLogMessage("Purchase attempted, response: " + str(response.status))
		if response.status != OK:
			UtilityPtr.addLogMessage("Error purchasing skin!")

func resetPurchases()-> void:
	if googlePayment:
		UtilityPtr.addLogMessage("Try to reset purchase")
		if not newSkinToken.is_empty():
			googlePayment.consumePurchase(newSkinToken)

func check_events()-> void:
	while apple_payment.get_pending_event_count() > 0:
		var event = apple_payment.pop_pending_event()
		if event.result == "ok":
			match event.type:
				"product_info":
					UtilityPtr.addLogMessage(str(event))
