extends Node

var split_timer: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	processLuca()

func reindex_array(original_array: Array) -> Array:
	var reindexed_array: Array = []

	# Iterate through the original array
	for element in original_array:
		# Only add non-empty elements to the new array
		if element != null:
			reindexed_array.append(element)

	return reindexed_array

func processLuca():
	#print("Luca.all.size() ", Luca.all.size())
	if Luca.all != null:
		for i in Luca.all:
			
			if i != null:
				
				if i.life_span < 0.0:
					#i.die()
					i.queue_free()
					Luca.all.erase(i)
					#Luca.all = reindex_array(Luca.all)
				#print(Luca.all[i].life_span)
				
				#body.apply_central_force(Vector2(randf_range(0, 2*PI), randf_range(0, 2*PI)))
				#if Luca.all[i].get_collision_exceptions().size() == 0:
					#print(Luca.all[0].get_collision_exceptions())
				else:
					move_luca_aimless(i)
					var newLuca
					#print("stamina: ", Luca.all[0].stamina)
					if i.stamina >= i.splitThreshold:
						#Luca.all[i].split_lucas()
						
						if Luca.all.size() < 200:
							newLuca = await split_luca(i)


var newLuca

func split_luca(luca: Luca):
	var scene = load("res://luca.tscn")
	
	newLuca = scene.instantiate()
	
	luca.add_collision_exception_with(newLuca)
	
	newLuca.position = luca.position
	newLuca.life_span = 200.0
	
	var rand1 = randf_range(-50, 50)
	var rand2 = randf_range(-50, 50)
	
	luca.apply_central_impulse(Vector2((-1)*20, (-1)*20))
	
	newLuca.apply_central_impulse(Vector2(20, 20))
	
	luca.stamina -= luca.splitThreshold
	newLuca.stamina = luca.stamina
	add_sibling(newLuca)
	
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	if Luca.all.has(luca) && Luca.all.has(newLuca) && is_instance_valid(luca):
		luca.remove_collision_exception_with(newLuca)
		return newLuca
	
func move_luca_aimless(luca: Luca):
	luca.apply_central_force(Vector2(randf_range(-100, 100), randf_range(-100, 100)))
	
	#luca.linear_velocity = Vector2(0.0, 0.0)
