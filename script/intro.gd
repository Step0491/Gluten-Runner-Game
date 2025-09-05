extends Node2D

@onready var http_request = $HTTPRequest  # 🔹 Assicurati di avere un nodo HTTPRequest nella scena

func _ready():
	var url = "https://gluten-runner-server.onrender.com/chat"
	
	var headers = ["Content-Type: application/json"]
	var data = {"message": "Ciao"}
	var json_data = JSON.stringify(data)

	if not http_request.is_connected("request_completed", Callable(self, "_on_server_response")):
		http_request.connect("request_completed", Callable(self, "_on_server_response"))

	http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)		
	await get_tree().create_timer(0.25).timeout

	$audio.play()                         # ► riproduci il suono “intro”
	$AnimationPlayer.play("Fade In")      # ► avvia fade-in video
		
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(1).timeout

	$AnimationPlayer.play_backwards("Fade In")
	await $AnimationPlayer.animation_finished

	get_tree().change_scene_to_file("res://scene/menu_principale.tscn")
