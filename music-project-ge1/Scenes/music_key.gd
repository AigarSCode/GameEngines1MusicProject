extends Area3D

var target:Vector3
var elapsed_time:float = 0.0
var trail_active:bool = false
var trail:Node
@export var trail_object:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = $"../Marker3D".global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Lerp the trail to the target while decreasing in size and opacity
	if trail_active && elapsed_time < 1:
		elapsed_time += delta
		# Lerp to target over 1 second
		var trail_pos = trail.position
		trail.position = trail_pos.lerp(target, elapsed_time)
		
		# Reduce trail scale while moving to target
		var trail_scale = trail.scale
		trail.scale = trail_scale.lerp(Vector3.ZERO, elapsed_time)
		
		# Reduce opacity while moving to target
		# TODO Get meshinstace3d from trail, get its mesh and then reduce the opacity
		
	else:
		# Once trail reaches target it is removed
		trail_active = false
		trail.queue_free()


# Functionality for when a collision occurs between the hand (Area3D) and this Area3D
func _on_area_entered(area: Area3D) -> void:
	# Play sound
	$"../AudioStreamPlayer3D".play()
	
	# Create trail effect to the Marker3D (target)
	trail = trail_object.instantiate()
	trail.position = global_position
	
	# Generate and set a random color
	var trailMesh:MeshInstance3D = trail.get_node("TrailMesh")
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(randf(), randf(), randf())
	trailMesh.set_surface_override_material(1, material)
	
	# Enable the trail
	trail_active = true
	add_child(trail)
