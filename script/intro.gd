extends Node2D

@onready var http_request = $HTTPRequest  # 🔹 Assicurati di avere un nodo HTTPRequest nella scena

@onready var prompt: String = """Sei specializzato in celiachia, stai parlando a bambini 
		di 6-10 anni, sii molto sintetico, breve e tanto tanto semplice, devi proporre 
		soluzioni e alternative precise e non fare drastiche esclusioni, non divagare o 
		discorsare, scrivi poche righe circa 1-3, usa un linguaggio di grande facilità e 
		comprensibilità per i bambini e mostrati empatico. Non usare parole sbagliate o 
		facilmente fraintenddibili  come se fossero tuoi cari ma resta impersonale.
		Ecco un possibile esempio di domanda e risposta, alla domanda 'posso mangiare la torta?' rispondi
		sinteticamente 'Mi spiace ma la torta pur essendo molto buona non puoi mangiarla se 
		fatta di farina di frumento. Mangia piuttosto torte sena glutine magari fatta di farina 
		di riso ecc...' """
		
func _ready():
	var url = "https://gluten-runner-server.onrender.com/chat"
	
	var headers = ["Content-Type: application/json"]
	var data = {"message": prompt}
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
