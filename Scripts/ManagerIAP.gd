class_name ManagerIAP extends Node

signal unlockNewSkin

func purchaseSkin()-> void:
	unlockNewSkin.emit()
