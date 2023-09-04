extends CanvasLayer

var points = 0
var lives = 0
var max_lives = 10
var wave = 0;
var player_texture: Texture2D

@onready var lives_container = $LivesContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.safe_connect(Constants.EVENT_UI_INITIALISE, on_ui_initialise)
	Events.safe_connect(Constants.EVENT_UI_UPDATE_LIVES, on_ui_update_lives)
	Events.safe_connect(Constants.EVENT_UI_UPDATE_POINTS, on_ui_update_points)
	Events.safe_connect(Constants.EVENT_UI_UPDATE_WAVE, on_ui_update_wave)
	
	player_texture = load("res://art/player_ui.png")
	
	
func on_ui_initialise(ui_data: Dictionary) -> void:
	init_lives_container()
	
	lives = ui_data["lives"]
	points = ui_data["points"]
	wave = ui_data["wave"]
	
	update_points()
	update_lives()
	update_wave()
	
	
func on_ui_update_lives(ui_data: Dictionary) -> void:
	lives = ui_data["lives"]
	update_lives()
	
	
func on_ui_update_points(ui_data: Dictionary) -> void:
	points += ui_data["points"]
	update_points()
	
	
func on_ui_update_wave(ui_data: Dictionary) -> void:
	wave = ui_data["wave"]
	update_wave()
	
	
func update_points() -> void:
	$Points.text = str(points)
	
	
func update_wave() -> void:
	$Wave.text = str(wave)
	
	
func update_lives() -> void:
	# Clear all lives - we add 1 here so that it becomes "2 lives in the lives
	# counter, plus the 1 one the playfield"
	for i in max_lives - lives + 1:
		lives_container.get_child(max_lives - i - 1).hide()
		
	for i in lives - 1:
		lives_container.get_child(i).show()
	
	
# Loads the lives container with 10 player sprites, which are
# subsequently hidden by update_lives()
func init_lives_container() -> void:
	if lives_container.get_child_count() > 0:
		return
		
	var sprite_spacing = Constants.UI_LIVES_SPACING
	var sprite_size = player_texture.get_size()
	
	for i in max_lives:
		var control = Sprite2D.new()
		control.texture = player_texture
		control.position.x = lives_container.size.x - (i * (sprite_size.x + sprite_spacing)) - (sprite_size.x / 2)
		control.position.y = Constants.UI_LIVES_OFFSET
		lives_container.add_child(control)
	
