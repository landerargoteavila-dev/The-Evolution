extends CharacterBody3D

@export var velocidad := 5.0

var camara: Camera3D

func _ready():
	camara = $Camera3D

func _physics_process(_delta):
	# Movimiento
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direccion = Vector3(input.x, 0, input.y).normalized()
	
	if direccion != Vector3.ZERO:
		velocity.x = direccion.x * velocidad
		velocity.z = direccion.z * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
		velocity.z = move_toward(velocity.z, 0, velocidad)
	
	move_and_slide()
	
	# Actualizar cámara
	if camara:
		camara.global_position = global_position + Vector3(0, 5, 8)
		camara.look_at(global_position)
