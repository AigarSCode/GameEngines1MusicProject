extends Node3D

var xr_interface: XRInterface
var button_start_marker:Vector3
var music_buttons:Array = []

var preset1_path = "res://Sounds/Papal Bell/"
var preset_samples1:Array = []

var preset2_path = "res://Sounds/Perc/"
var preset_samples2:Array = []

var active_preset:String = "preset1"

@export var button_scene:PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_XR()
	
	button_start_marker = $Marker3D.global_position
	
	# Read Samples and create starting preset
	read_all_sounds(preset1_path, preset_samples1)
	read_all_sounds(preset2_path, preset_samples2)
	
	load_preset("preset1")
	
	# Create signals for the other buttons
	var preset1 = $Preset1Button.get_node("Area3D")
	preset1.type = "preset1"
	preset1.connect("presetPressed", Callable(self, "load_preset"))
	var preset2 = $Preset2Button.get_node("Area3D")
	preset2.type = "preset2"
	preset2.connect("presetPressed", Callable(self, "load_preset"))
	var reverb = $ReverbButton.get_node("Area3D")
	reverb.type = "reverb"
	#reverb.connect("presetPressed", Callable(self, "load_preset"))
	


# Instantiating the row of buttons and setting the sound stream
func create_music_row(preset: Array) -> void:
	var pos = button_start_marker
	
	for i in range(len(preset)):
		var music_button = button_scene.instantiate() 
		var music_button_audio:AudioStreamPlayer3D = music_button.get_node("AudioStreamPlayer3D")
		music_button_audio.set_stream(load(preset[i]))
		
		music_button.position = pos
		add_child(music_button)
		
		# Change pos for next button
		pos += Vector3(0.25,0,0)
		music_buttons.append(music_button)


# Reading all sounds from a directory into a preset array
func read_all_sounds(path: String, preset_array: Array) -> void:
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	if dir != null:
		var sample = dir.get_next()
		while sample != "":
			# Only take wav files and not the wav.import files
			if sample.ends_with(".wav"):
				print("Sample: " + sample)
				preset_array.append(path + sample)
			sample = dir.get_next()
	else:
		print("Failed to read Samples")


# Functionality for loading presets
func load_preset(preset: String):
	if preset == "preset1":
		print("Loading preset 1")
		unload_preset()
		create_music_row(preset_samples1)
	if preset == "preset2":
		print("Loading preset 2")
		unload_preset()
		create_music_row(preset_samples2)


# Functionality for unloading presets
func unload_preset():
	# Cycle through samples and remove them
	if !music_buttons.is_empty():
		for button in music_buttons:
			button.queue_free()
		music_buttons.clear()


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
