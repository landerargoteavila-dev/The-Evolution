extends 	Node3D

@export var velocidad := 2.0
@export var rango_deteccion := 5.0
@export var salud_maxima := 50.0

var salud_actual := 50.0
var jugador: Node3D
var tiempo := 0.0

func _ready():
	jugador = get_tree().get_first_node_in_group("jugador")
	add_to_group("enemigos")
	crear_barra_vida()
	actualizar_barra()

func crear_barra_vida():
	var barra = Node3D.new()
	barra.name = "BarraVida"
	add_child(barra)
	barra.position.y = 1.2
	
	# Fondo
	var fondo = MeshInstance3D.new()
	fondo.mesh = BoxMesh.new()
	(fondo.mesh as BoxMesh).size = Vector3(0.8, 0.08, 0.04)
	var mat_fondo = StandardMaterial3D.new()
	mat_fondo.albedo_color = Color(0.2, 0.2, 0.2)
	fondo.material_override = mat_fondo
	fondo.name = "Fondo"
	barra.add_child(fondo)
	
	# Barra
	var barra_vida = MeshInstance3D.new()
	barra_vida.mesh = BoxMesh.new()
	(barra_vida.mesh as BoxMesh).size = Vector3(0.8, 0.08, 0.04)
	var mat_barra = StandardMaterial3D.new()
	mat_barra.albedo_color = Color(0.0, 1.0, 0.0)
	barra_vida.material_override = mat_barra
	barra_vida.name = "Barra"
	barra.add_child(barra_vida)

func actualizar_barra():
	var barra = get_node_or_null("BarraVida/Barra")
	if barra:
		var porcentaje = salud_actual / salud_maxima
		barra.scale.x = max(porcentaje, 0.0)
		var mat = barra.material_override
		if porcentaje > 0.6:
			mat.albedo_color = Color(0.0, 1.0, 0.0)
		elif porcentaje > 0.3:
			mat.albedo_color = Color(1.0, 1.0, 0.0)
		else:
			mat.albedo_color = Color(1.0, 0.0, 0.0)

func _physics_process(delta):
	tiempo += delta
	
	# Flotación (sube y baja)
	position.y = 0.5 + sin(tiempo * 0.8) * 0.1
	
	# Perseguir al jugador
	if jugador:
		var distancia = position.distance_to(jugador.position)
		if distancia < rango_deteccion:
			var direccion = (jugador.position - position).normalized()
			position += direccion * velocidad * delta
			look_at(Vector3(jugador.position.x, position.y, jugador.position.z))
		
		# Dañar al jugador si lo toca
		if distancia < 0.8:
			if jugador.has_method("recibir_dano"):
				jugador.recibir_dano(10.0)
				# Retroceder
				var dir = (position - jugador.position).normalized()
				position += dir * 0.3

func recibir_dano(cantidad: float):
	salud_actual -= cantidad
	if salud_actual < 0:
		salud_actual = 0
	actualizar_barra()
	if salud_actual <= 0:
		morir()

func morir():
	print("💀 Enemigo muerto")
	queue_free()
