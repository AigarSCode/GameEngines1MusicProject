extends Area3D

var target:Vector3
var elapsed_time:float = 0.0
var trail_active:bool = false
var trail:Node
var type:String
@export var trail_object:PackedScene

# Button Colours
var buttonTopMesh:MeshInstance3D
var selected:bool = false
var selectedColor:Color = Color8(0, 151, 23)
var unselectedColor:Color = Color8(233, 0, 25)

# Audio Effects
var reverb:bool = false

# Signals
signal presetPressed
signal reverbPressed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = $"../Marker3D".global_position
	buttonTopMesh = $ButtonTop/ButtonTopMesh


func _physics_process(delta: float) -> void:
	# Lerp the trail to the target while decreasing in size and opacity
	if trail_active and elapsed_time < 1:
		elapsed_time += delta
		# Lerp to target over 1 second
		var trail_pos = global_position
		trail.position = trail_pos.lerp(target, elapsed_time)
		
		# Reduce trail scale while moving to target
		var trail_scale = trail.scale
		trail.scale = trail_scale.lerp(Vector3.ZERO, elapsed_time)
		
		# Reduce opacity while moving to target
		var mesh = trail.get_node("TrailMesh")
		var material = mesh.get_surface_override_material(0)
		var color = material.albedo_color
		material.albedo_color = Color(color.r, color.g, color.b, (color.a - elapsed_time))
		
	elif trail_active:
		# Once trail reaches target it is removed
		elapsed_time = 0.0
		trail.queue_free()
		trail_active = false


# Functionality for when a collision occurs between the hand (Area3D) and this Area3D
func _on_area_entered(area: Area3D) -> void:

	# First check if this button has a sound stream
	if $"../AudioStreamPlayer3D".get_stream() != null:
		$"../AudioStreamPlayer3D".play()
		
		# Only create a new trail after the previous one has been removed
		if trail == null:
			# Create trail effect to the Marker3D (target)
			trail = trail_object.instantiate()
			trail.global_transform = self.global_transform
			
			# Generate and set a random color
			var trailMesh:MeshInstance3D = trail.get_node("TrailMesh")
			var material = StandardMaterial3D.new()
			material.albedo_color = Color(randf(), randf(), randf())
			trailMesh.set_surface_override_material(0, material)
			
			# Enable the trail
			trail_active = true
			add_child(trail)
	elif type == "preset1":
		emit_signal("presetPressed", "preset1")
	elif type == "preset2":
		emit_signal("presetPressed", "preset2")
	elif type == "reverb":
		selected = !selected
		
		# Change the color when selected
		change_color()
		
		emit_signal("reverbPressed")


# Toggle button color for reverb
func change_color():
	var material = StandardMaterial3D.new()
	buttonTopMesh.set_surface_override_material(0, material)
	
	if selected:
		material.albedo_color = selectedColor
	else:
		material.albedo_color = unselectedColor
