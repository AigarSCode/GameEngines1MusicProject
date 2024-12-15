# Music Keys

Name: Aigars Semjonovs

Student Number: C21322311

Video: [https://youtu.be/fIsWpAPuDCM](https://youtu.be/fIsWpAPuDCM)

# Description of the project
This project is made for the Game Engines 1 Module run by Bryan Duggan.
This is a simple project in which you play with Music keys, you select a preset, enable/disable reverb and tap on the keys to make sounds.
The music tiles are automatically created with their sound attached to them. 
You can currently have 2 presets. There is a reverb option that can be enabled for a reverb effect.


# Instructions for use
- Open project in Godot. 
- Create two folders within the Sounds/ directory, fill them with up to 15 wav sound files (Less than 15 for best experience)
- Inside "music_scene.gd" adjust the folder path for "preset1_path" and "preset2_path".
- Plug in an XR headset, for best experience use Meta Quest 2/3 (Tested on Quest 2)
- Run the project


# How it works
## Main Scene "MusicScene.tscn"
This is the main scene used, it contains the XROrigin along with DirectionalLight, Preset Buttons, Reverb button and others. 

## Main Scene Script "music_scene.gd"
This script controls the main scene and it:
- Reads all of the sound files
- Instantiates "MusicKey.tscn" scenes using the sound files
- Initializes XR Passthrough
- Configures the Signals used
- Handles some button functions, such as Reverb and Preset management (Load/Unload)

## Music Key Scene "MusicKey.tscn"
This is the scene that holds the button, made of Area3D, CollisionShape, MeshInstance and AudioStreamPlayer.

## Music Key Script "music_key.gd"
This script controls controls most of the button functions as well as:
- Signal Emitting
- Trail Effect creation
- Collision (Click) detection
- Multiple types of buttons handled (Music Key, Preset and Reverb)
- Color Change
- Audio Playing

## Trail Scene "Trail.tscn"
Simple scene containing a square MeshInstance that is used and instantiated when a trail is created.


# List of classes/assets in the project
| Class/asset | Source |
|-----------|-----------|
| music_scene.gd | Self written except for XR init [Code](https://github.com/skooter500/GE1-2024/blob/main/games-engines-2024/music_toys.gd) |
| music_key.gd | Self written |
| MusicScene.tscn | Self written |
| MusicKey.tscn | Self written |
| Trail.tscn | Self written |


# Code Review
## music_scene.gd
### _ready()
Does the initial setup of necessary variables.
- First calls the "init_XR()" function to initialize XR
- Sets the starting position "button_start_marker" which is used when instantating music keys in a row
- Calls "read_all_sounds()" for loading audio files into an array
- Loads the starting preset using "load_preset()"
- Sets signal connections for all preset and reverb buttons

### create_music_row()
Creates a the row of music keys with sound files.
- Create x number of "button_scene" (MusicKey.tscn) instances
- Set the audio stream for each instance
- Set the position of the button starting from "button_start_marker"
- Increment the position by 0.25 units for each button
- Adds the instance to the "music_buttons" array for future use

### read_all_sounds()
Reads the sound files from the 2 folders inside Sounds/
- Open the directory using the path
- "list_dir_begin()" is necessary to read the files
- For as long as there are new ".wav" files, read them into a "preset_array"

### load_preset()
Used for loading a Preset and changing the button Color
- Depending on the preset being used, change its "selected" boolean and call "change_color()"
- Call "unload_preset()" to remove the previous music keys if they exist
- Call "create_music_row()" to make the row of music keys
- Finally call "change_reverb_on_players()", this applies reverb to the audio streams if the reverb button is pressed when the preset is changed

### unload_preset()
Cycle through each instance of "music_buttons" and remove them, this removes them from the scene
- Check if a preset is active, indicated by "music_buttons" having instances within
- Call "queue_free()" to queue them for removal
- Empty the array after

### enable_reverb()
Enable reverb
- Change "reverb" boolean
- Apply changes with "change_reverb_on_players()"

### change_reverb_on_players()
This changes the audio bus from "Master" to "ReverbBus" and back
- Master contains no audio modification and ReverbBus has the reverb audio effect
- If "reverb" is active, cycle through each button and change it to "ReverbBus"
- Same for if "reverb" is not active, change bus to "Master"

### init_XR()
Used to initialize XR
- Verify that the interfaces are initialized
- Disable VSync
- Change output to headset
- Enable Alpha blend mode which is passthrough
- Set the environment to be clear


## music_key.gd
### _ready()
Sets initial variables
- "target" which is a target position for the trail
- "buttonTopMesh" is the MeshInstance that is used to change color, indicating clicked or not

### _physics_process()
Handles Trail effect
- If "trail_active" is true, trail movement is calculated
- A trail lasts for 1 second and it moves from its parent position to the target position using "lerp()"
- During the lerp, its scale is reduced over time
- Opacity is also reduced during the lerp
- Once the trail is not active, it is queued for removal

### _on_area_entered()
This handles all button collisions/presses
- First check is for if its one of the music keys, if it has an audio stream
- Play the sound, make the trail by instantiating the "Trail.tscn" scene and set "trail_active"
- Set the color of the trail to a random value
- For Preset buttons, emit a signal for "presetPressed" which calls "load_preset()" in the "main_scene.gd" script
- For the reverb button, flip the "selected" value, "change_color()" and emit signal "reverbPressed"
- Signal "reverbPressed" is used to call "enable_reverb()" in the "main_scene.gd" script

### change_color()
This simply changes the color of the button MeshInstance
- Make a new material
- Change its "albedo_color" based on the value of "selected"


# What I am most proud of in the assignment
I am most proud of the progress I have made in terms of understanding Godot and its sytems, from creating scenes to writing scripts that interact effectively.
The assignment involved a lot of testing and trial and error to get things right and functioning smoothly.


# What I learned
I learned a tremendous amount throughout the development process including:
- Scene Instance Management
- Directory Interaction
- Audio Modification
- XR Implementation
- The use of Signals
- Button Interaction


# References
* XR init code from Bryan Duggan [Source](https://github.com/skooter500/GE1-2024/blob/main/games-engines-2024/music_toys.gd)
* Some sound samples used from [99Sounds](https://99sounds.org/drum-samples/), not included here.

