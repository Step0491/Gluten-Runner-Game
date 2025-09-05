extends Control

@onready var chat_messages = $PanelContainer/ScrollContainer/VBoxContainer
@onready var http_request = $HTTPRequestGroq  # 🔹 Assicurati di avere un nodo HTTPRequest nella scena

func _ready() -> void:
	$AnimationPlayer.play("dark")
	await $AnimationPlayer.animation_finished

	# 🔹 Aggiungi messaggio iniziale del bot
	_add_message_bubble("Ciao, io sono Gluten-Bot, come posso esserti utile?", false)



# ======================
# Invio prompt al server
# ======================
func send_prompt_to_server(prompt: String) -> void:
	var url = "https://gluten-runner-server.onrender.com/chat"
	
	var headers = ["Content-Type: application/json"]
	var data = {"message": prompt}
	var json_data = JSON.stringify(data)

	if not http_request.is_connected("request_completed", Callable(self, "_on_server_response")):
		http_request.connect("request_completed", Callable(self, "_on_server_response"))

	http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)


func _on_server_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var response = json.data
			if response.has("reply"):
				var reply = response["reply"]
				print("Risposta dal server:", reply)
				_add_message_bubble(reply, false)  # 🔹 Risposta IA (a sinistra)
	else:
		print("Errore server:", response_code)


# ======================
# Bottone invio messaggio
# ======================
func _on_groq_button_pressed() -> void:
	var user_msg = $Groq_input.text.strip_edges()  # 🔹 così elimini spazi inizio/fine
	if user_msg == "":
		return
	
	# 🔹 Aggiungi messaggio utente (a destra)
	_add_message_bubble(user_msg, true)

	# 🔹 Invia al server esterno
	send_prompt_to_server(
		"Sei specializzato in alimentazione e celiachia, non rispondere a domande non inerenti, " + user_msg
	)

	$Groq_input.text = ""



# ======================
# Uscita al menu
# ======================
func _on_groq_exit_pressed() -> void:
	$AnimationPlayer.play_backwards("dark")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/menu_principale.tscn")


# ======================
# Gestione bolle messaggi
# ======================
func _add_message_bubble(text: String, from_user: bool) -> void:
	var bubble = preload("res://scene/message_bubble.tscn").instantiate()
	var label = bubble.get_node("VBoxContainer/Groq_output")
	label.text = text

	var custom_font = load("res://materials/Super Lobster.ttf")
	label.add_theme_font_override("font", custom_font)
	label.add_theme_font_size_override("font_size", 30)
	label.add_theme_constant_override("outline_size", 6)
	label.add_theme_color_override("font_outline_color", Color.BLACK)

	if from_user:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.add_theme_color_override("font_color", Color.WHITE)

		var style = StyleBoxFlat.new()
		style.bg_color = "#303030cc"
		style.corner_radius_top_left = 20
		style.corner_radius_top_right = 20
		style.corner_radius_bottom_left = 20
		style.corner_radius_bottom_right = 20
		style.expand_margin_left = 8
		style.expand_margin_right = 8
		style.expand_margin_top = 8
		style.expand_margin_bottom = 8
		label.add_theme_stylebox_override("normal", style)

	else:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.add_theme_color_override("font_color", Color.WHITE)

		var style = StyleBoxFlat.new()
		style.bg_color = "#171717cc"
		style.corner_radius_top_left = 20
		style.corner_radius_top_right = 20
		style.corner_radius_bottom_left = 20
		style.corner_radius_bottom_right = 20
		style.expand_margin_left = 8
		style.expand_margin_right = 8
		style.expand_margin_top = 8
		style.expand_margin_bottom = 8
		label.add_theme_stylebox_override("normal", style)

	chat_messages.add_child(bubble)

	await get_tree().process_frame
	var vbar = $PanelContainer/ScrollContainer.get_v_scroll_bar()
	vbar.value = vbar.max_value
