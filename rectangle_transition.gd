extends Node2D

var screen_size
var num_rects = 20
var step_x
var step_y
var current_step = 0
var current_rect : Vector4

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	step_x = screen_size.x / (num_rects * 2)
	step_y = screen_size.y / (num_rects * 2)
	
	current_rect.x = (screen_size.x / 2) + (step_x / 2)
	current_rect.y = (screen_size.y / 2) - (step_y / 2)
	
	current_rect.w = step_x * current_step * 2
	current_rect.z = step_y * current_step * 2

	timer.wait_time = 0.025
	timer.one_shot = true
	timer.connect("timeout", on_timer_timeout)
	timer.start()

func on_timer_timeout():
	if current_step < num_rects:
		print(current_rect.x, " " , current_rect.y, " ", current_rect.w, " ", current_rect.z)

		current_step += 1
		current_rect.x = current_rect.x - step_x
		current_rect.y = current_rect.y - step_y
		current_rect.w = step_x * current_step * 2
		current_rect.z = step_y * current_step * 2

		timer.start()

func _process(delta):
	queue_redraw()
	
func _draw():
	#draw_rect(Rect2(624, 351, 656, 369), Color.GREEN)
	draw_rect(Rect2(current_rect.x, current_rect.y, current_rect.w, current_rect.z), Color.GREEN, false, 20.0)
	#draw_rect(Rect2(current_rect.w, current_rect.y, current_rect.x, current_rect.z), Color.GREEN, false, 4.0)
