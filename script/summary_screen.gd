extends Control

@onready var menu = "res://scene/menu_principale.tscn"
@onready var retry = "res://scene/main.tscn"

@onready var volume_button = $VBoxContainer/volume_button
@onready var volume_btn = $VBoxContainer/volume_button/volume_btn

@onready var food_name_label_1 = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/food_name
@onready var food_quantity_label_1 = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/quantity
@onready var food_description_label_1 = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/food_description
@onready var food_texture_rect_1 = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect

@onready var food_name_label_2 = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/food_name
@onready var food_quantity_label_2 = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/quantity
@onready var food_description_label_2 = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/food_description
@onready var food_texture_rect_2 = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect

@onready var food_name_label_3 = $PanelContainer/VBoxContainer/HBoxContainer3/VBoxContainer/food_name
@onready var food_quantity_label_3 = $PanelContainer/VBoxContainer/HBoxContainer3/VBoxContainer/quantity
@onready var food_description_label_3 = $PanelContainer/VBoxContainer/HBoxContainer3/VBoxContainer2/food_description
@onready var food_texture_rect_3 = $PanelContainer/VBoxContainer/HBoxContainer3/VBoxContainer/TextureRect

var current_page = 0
var labels = []

# Update UI for the current page
func update_food_ui():
	var collected_food = GameStats.collected_food
	var total_food = GameStats.food_count()
	var pages = int(ceil(float(total_food) / 3.0))
	
	# Clear previous labels
	for l in labels:
		l[0].text = ""
		l[1].text = ""
		l[2].texture = null
		l[3].text = ""

	# Set the labels for the current page
	var start_index = current_page * 3
	var end_index = min(start_index + 3, total_food)
	var index = 0

	for i in range(start_index, end_index):
		var food_name = collected_food.keys()[i]
		labels[index][0].text = food_name.capitalize()
		labels[index][1].text = food_descriptions[food_name]
		labels[index][2].texture = load("res://ScreenCibo/%s.png" % food_name)
		labels[index][3].text = "%d" % collected_food[food_name]
		index += 1

	$page_number.text = "%d/%d" % [current_page + 1, pages]

# Function to reset collected food
func reset():
	GameStats.collected_food.clear()
	current_page = 0
	update_food_ui()

# Called when the scene is ready
func _ready():
	$".".modulate = "000000"
	# Ricollega il bottone volume se necessario
	if not volume_btn.is_connected("pressed", volume_btn._on_pressed):
		volume_btn.pressed.connect(volume_btn._on_pressed)

	volume_btn.update_button_style()

	labels = [
		[food_name_label_1, food_description_label_1, food_texture_rect_1, food_quantity_label_1],
		[food_name_label_2, food_description_label_2, food_texture_rect_2, food_quantity_label_2],
		[food_name_label_3, food_description_label_3, food_texture_rect_3, food_quantity_label_3]
	]

	update_food_ui()
	update_food_counts()
	
	await get_tree().process_frame
	$AnimationPlayer.play("dark")
	await $AnimationPlayer.animation_finished
	

# Handle exit button press
func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	reset()
	get_tree().change_scene_to_file(menu)

# Handle retry button press
func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	reset()
	get_tree().change_scene_to_file(retry)

# Handle right button press (next page)
func _on_button_right_pressed() -> void:
	var total_food = GameStats.food_count()
	var pages = int(ceil(float(total_food) / 3.0))

	if current_page < pages - 1:
		current_page += 1
		update_food_ui()

# Handle left button press (previous page)
func _on_button_left_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		update_food_ui()

func update_food_counts():
	var collected_food = GameStats.collected_food
	var bad_foods := [
		"birra", "pane", "burrito", "cereali", "cheeseburger", "biscotti",
		"cornetto", "ciambella", "hotdog", "pancake", "pizza",
		"spaghetti", "taco"
	]

	var total_good := 0
	var total_bad := 0
		
	for food_name in collected_food.keys():
		var quantity :int = collected_food[food_name]
		if bad_foods.has(food_name):
			total_bad += quantity
		else:
			total_good += quantity
	
	

var food_descriptions: Dictionary = {
	"mela": "Frutto senza glutine, fresco e ricco di fibre. Adatto ai celiaci, nessun rischio di contaminazione crociata.",
	"succo di mela": "Bevanda dolce, senza glutine ma zuccherata. Solitamente sicuro per celiaci, ma verificare eventuali impianti condivisi.",
	"avocado": "Ricco di grassi buoni, perfetto per ogni dieta. Totalmente sicuro per celiaci, senza rischio di contaminazione.",
	"bacon e uova": "Proteico ma grasso, adatto se non vegetariano. Sicuro per celiaci solo se cotto senza contaminazioni (es. stesso piano cottura del pane).",
	"banana": "Energetica e senza glutine, ideale come snack. Naturalmente adatta ai celiaci, nessun rischio di contaminazione.",
	"birra": "Contiene glutine, sconsigliata ai celiaci. Deve essere assolutamente evitata.",
	"pane": "Contiene glutine, base comune in molte diete. Vietato per celiaci, altissimo rischio. Optare per varianti a base di farina di riso, avena o legumi",
	"burrito": "Contiene glutine, attenzione in caso di intolleranze. Sconsigliato ai celiaci; possibile contaminazione anche con versioni 'gluten free'.",
	"burro": "Senza glutine, ma ricco di grassi. Sicuro per celiaci, ma evitare contaminazioni con coltelli usati su pane.",
	"carota": "Leggera, fresca e naturalmente senza glutine. Nessun rischio per i celiaci, se lavata correttamente.",
	"cereali": "Spesso contengono glutine, controllare gli ingredienti. Anche le versioni senza glutine possono essere contaminate.",
	"formaggio": "Ricco di calcio, senza glutine ma grasso. Sicuro per celiaci, tranne quelli aromatizzati con ingredienti a rischio.",
	"cheeseburger": "Contiene glutine e lattosio, da evitare in diete restrittive. Non adatto ai celiaci per via del pane e possibili salse.",
	"cioccolata": "Senza glutine ma calorico, attenzione alle quantità. Verificare sempre l’etichetta: rischio di contaminazione da linee produttive miste.",
	"biscotti": "Contiene glutine e zuccheri, da limitare. Non adatto ai celiaci, anche in piccole quantità. Optare per varianti a base di farina di riso o avena",
	"cornetto": "Alta presenza di glutine e burro, da evitare per intolleranti. Prodotto da forno altamente sconsigliato per celiaci. Optare per varianti a base di farina di riso",
	"ciambella": "Contiene glutine e zuccheri, non adatto ai celiaci. Inoltre, è spesso cotto in olio condiviso, aumentando il rischio.",
	"pesce": "Fonte magra di proteine, senza glutine. Sicuro per celiaci se non impanato o cotto con alimenti contenenti glutine.",
	"hotdog": "Contiene glutine e conservanti, attenzione in diete sensibili. Il pane lo rende inadatto ai celiaci, rischio alto anche con salse.",
	"kiwi": "Ricco di vitamina C, 100% senza glutine. Totalmente sicuro per celiaci, nessun rischio.",
	"lattuga": "Leggera e fresca, perfetta in ogni dieta. Naturalmente priva di glutine, sicura per celiaci.",
	"melanzana": "Verdura versatile e senza glutine. Nessun rischio per i celiaci se non preparata con pangrattato o simili.",
	"latte": "Fonte di calcio, attenzione se intolleranti al lattosio. Non contiene glutine, sicuro per i celiaci.",
	"pancake": "Contiene glutine, da evitare per celiaci. Anche le versioni senza glutine vanno cotte separatamente per evitare contaminazioni.",
	"patatine": "Senza glutine ma molto salate e fritte. Verificare l’olio usato: se condiviso con altri alimenti contenenti glutine c’è rischio di contaminazione crociata.",
	"pizza": "Contiene glutine, da evitare per i celiaci. Anche le pizze 'gluten free' devono essere cotte in forni separati.",
	"pollo": "Carne magra, senza glutine e altamente proteica. Sicuro per celiaci se non impanato o cucinato con altri alimenti con glutine.",
	"pomodori": "Ortaggio senza glutine, ricco di antiossidanti. Nessun rischio per i celiaci.",
	"riso": "Senza glutine, base perfetta per molte ricette. Sicuro per i celiaci, ma attenzione a condimenti o salse.",
	"spaghetti": "Contiene glutine, optare per versioni speciali se intolleranti. Attenzione alla contaminazione durante la cottura.",
	"carne": "Proteine pure, senza glutine, attenzione alla cottura. Sicuro per celiaci se non marinato in salse contenenti glutine.",
	"sushi": "Spesso senza glutine, ma controllare la salsa di soia. Uso di salsa di soia standard è rischioso: preferire quella gluten free.",
	"taco": "Può contenere glutine, attenzione alla tortilla. Alcune versioni sono gluten free, ma rischio contaminazione è alto.",
	"tonno": "Senza glutine e ricco di Omega 3. Sicuro per i celiaci se al naturale, attenzione alle conserve aromatizzate.",
	"yogurt": "Senza glutine, attenzione agli zuccheri aggiunti. Verificare aromi e addensanti: alcune marche contengono glutine."
}
