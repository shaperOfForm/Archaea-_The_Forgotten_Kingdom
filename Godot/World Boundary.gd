extends StaticBody2D

static var all: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():

	get_node("%Bottom").shape.set_distance(get_viewport_rect().size.y * -1)
	get_node("%Top").shape.set_distance(0)
	get_node("%Left").shape.set_distance(0)
	get_node("%Right").shape.set_distance(get_viewport_rect().size.x * -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
