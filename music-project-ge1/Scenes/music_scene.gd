extends Node3D

var xr_interface: XRInterface
var button_start_marker:Vector3

@export var button:PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_XR()
	
	button_start_marker = $Marker3D.global_position
	create_music_row()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Instantiating the row of buttons
func create_music_row() -> void:
	var pos = button_start_marker
	for i in range(10):
		var button_scene = button.instantiate()
		
		button_scene.position = pos
		add_child(button_scene)
		
		pos += Vector3(0.25,0,0)


# XR Initialisation code by Bryan Duggan
func init_XR() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
		elif XRInterface.XR_ENV_BLEND_MODE_ADDITIVE in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ADDITIVE
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	get_window().set_current_screen(1)
	
	get_viewport().transparent_bg = true
	$WorldEnvironment.environment.background_mode = Environment.BG_CLEAR_COLOR
	$WorldEnvironment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	get_window().set_current_screen(1)
