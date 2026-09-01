extends Control

func _ready():
	# Conectar botones
	$BotonNuevoJuego.pressed.connect(_on_nuevo_juego_pressed)
	$BotonOpciones.pressed.connect(_on_opciones_pressed)
	$BotonSalir.pressed.connect(_on_salir_pressed)

func _on_nuevo_juego_pressed():
	# Ir al juego
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_opciones_pressed():
	# Mostrar opciones (por ahora solo un mensaje)
	print("🛠️ Opciones - Pendiente de implementar")

func _on_salir_pressed():
	# Salir del juego
	get_tree().quit()
