class_name Cockpit extends Node3D

@onready var lever: Lever = $Lever
@onready var lever_2: Lever = $Lever2
@onready var interactable_button: InteractableButton = $InteractableButton
@onready var fuse_box: FuseBox = $FuseBox
@onready var screen: Screen = $Screen

@onready var status_light_movement: StatusLight = $StatusLightMovement
@onready var status_light_gun: StatusLight = $StatusLightGun
@onready var status_light_tv: StatusLight = $StatusLightTV

@onready var generator_plug: GeneratorPlug = $SwitchBoard/GeneratorPlug
@onready var generator_plug_2: GeneratorPlug = $SwitchBoard/GeneratorPlug2
@onready var generator_plug_3: GeneratorPlug = $SwitchBoard/GeneratorPlug3
@onready var plug: Plug = $SwitchBoard/MainGeneratorPlug/Plug
@onready var plug_2: Plug = $SwitchBoard/MainGeneratorPlug/Plug2

@onready var tracks_plug_socket: PlugSocket = $SwitchBoard/TracksPlugSocket
@onready var lights_plug_socket: PlugSocket = $SwitchBoard/LightsPlugSocket
@onready var tv_plug_socket: PlugSocket = $SwitchBoard/TVPlugSocket
@onready var gun_plug_socket_1: PlugSocket = $SwitchBoard/GunPlugSocket1
@onready var gun_plug_socket_2: PlugSocket = $SwitchBoard/GunPlugSocket2

@onready var light_bulb: LightBulb = $LightBulb


var _mecha: Mecha
var _right_thread: float
var _left_thread: float
var _fire_cooldown: float
var _gun_sockets: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_mecha = Mecha.instance
	lever.value_changed.connect(_right_thread_lever)
	lever_2.value_changed.connect(_left_thread_lever)
	interactable_button.pressed.connect(_button_pressed)
	
	tracks_plug_socket.powered_state_changed.connect(func(x: bool) -> void: status_light_movement.powered = x)
	
	gun_plug_socket_1.powered_state_changed.connect(gun_socket_powered)
	gun_plug_socket_2.powered_state_changed.connect(gun_socket_powered)
	
	generator_plug.plug.socket = tv_plug_socket
	generator_plug_2.plug.socket = gun_plug_socket_1
	generator_plug_3.plug.socket = lights_plug_socket
	plug.socket = tracks_plug_socket
	plug_2.socket = gun_plug_socket_2
	
	lights_plug_socket.powered_state_changed.connect(func(x: bool) -> void: light_bulb.powered = x)
	tv_plug_socket.powered_state_changed.connect(func(x: bool) -> void: screen.powered = x; status_light_tv.powered = x)
	_mecha.hitbox.damaged.connect(damaged)

func _process(delta: float) -> void:
	if not _mecha: return
	if tracks_plug_socket.powered:
		_mecha.left_track = _left_thread
		_mecha.right_track = _right_thread
	else:
		_mecha.left_track = 0.0
		_mecha.right_track = 0.0
	_fire_cooldown -= delta

func _button_pressed() -> void:
	if not gun_plug_socket_1.powered or not gun_plug_socket_2.powered: return
	if _fire_cooldown > 0.0: return
	if fuse_box.good_fuses != 3: return
	if randf() > 0.66:
		fuse_box.fry()
	_mecha.fire_laser()
	_fire_cooldown = 1.0

func _right_thread_lever(value: float) -> void:
	if (absf(value) > 0.1):
		_right_thread = value
	else:
		_right_thread = 0.0

func _left_thread_lever(value: float) -> void:
	if (absf(value) > 0.1):
		_left_thread = value
	else:
		_left_thread = 0.0

func gun_socket_powered(value: bool) -> void:
	if value:
		_gun_sockets += 1
	else:
		_gun_sockets -= 1
	status_light_gun.powered = _gun_sockets == 2

func damaged(amount: float) -> void:
	if generator_plug_3.has_power:
		generator_plug_3.has_power = false
		return
	if generator_plug.has_power:
		generator_plug.has_power = false
		return
	if generator_plug_2.has_power:
		generator_plug_2.has_power = false
		return
