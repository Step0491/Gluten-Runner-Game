extends Node

var save_path := "user://profilo_stats.save"


var user_name = "Giocatore"
var num_partite_giocate:int = 0
var tempo_totale:float = 0.0
var tempo_massimo:float = 0.0
var tempo_ultima:float = 0.0
var total_good:int = 0
var total_bad:int = 0
var total_food:int = 0
var last_game_food: Dictionary = {}  # Dizionario dei cibi ultima partita

func _ready():
	carica_statistiche()

func salva_statistiche():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data = {
		"user_name": user_name,
		"num_partite_giocate": num_partite_giocate,
		"tempo_totale": tempo_totale,
		"tempo_massimo": tempo_massimo,
		"tempo_ultima": tempo_ultima,
		"total_good": total_good,
		"total_bad": total_bad,
		"total_food": total_food,
		"last_game_food": last_game_food  
	}
	file.store_string(JSON.stringify(data))
	file.close()


func carica_statistiche():
	if not FileAccess.file_exists(save_path):
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY:
		user_name = data.get("user_name", "Giocatore")
		num_partite_giocate = data.get("num_partite_giocate", 0)
		tempo_totale = data.get("tempo_totale", 0.0)
		tempo_massimo = data.get("tempo_massimo", 0.0)
		tempo_ultima = data.get("tempo_ultima", 0.0)
		total_good = data.get("total_good", 0)
		total_bad = data.get("total_bad", 0)
		total_food = data.get("total_food", 0)
		last_game_food = data.get("last_game_food", {})  


func aggiorna_statistiche(tempo_partita: float, good: int, bad: int, partita_food: Dictionary):
	num_partite_giocate += 1
	tempo_totale += tempo_partita
	tempo_ultima = tempo_partita
	if tempo_partita > tempo_massimo:
		tempo_massimo = tempo_partita
	total_bad = bad
	total_good = good
	total_food += (bad + good)
	
	# Salva il dizionario della partita
	last_game_food = partita_food.duplicate(true)  # copia indipendente
	salva_statistiche()

func first_time_name(text: String) -> void:
	user_name = text.strip_edges()
	if user_name == "":
		user_name = "Giocatore"
	# Non azzerare i dati qui, salva solo il nome
	salva_statistiche()
