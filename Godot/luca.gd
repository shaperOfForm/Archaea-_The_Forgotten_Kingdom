class_name Luca

extends Node2D

static var all: Array

# Exported properties
@export var maxStamina: float = 100.0
@export var splitThreshold: float = 80.0
@export var speed: float = 200
var velocity: Vector2
var acceleration: Vector2
var stamina: float


func _init():

		# Initialize stamina
	self.stamina = 0.0
	all.append(self)

func _ready():
	
	var luca = Luca.new()

func _process(delta: float):
	
	if all != null:
		
		for i in range(all.size()-1):
		# Simulate stamina increase over time
			#print(all[0].stamina)
			all[i].stamina += delta * 20.0  # Adjust the rate as needed
		
			
func _physics_process(delta):
	
	if all != null:
		for i in range(all.size()-1):
			if all[i] != null && all[i].get_node("RigidBody2D") != null:
				
				all[i].get_node("RigidBody2D").apply_central_force(Vector2(randf_range(0, 2*PI), randf_range(0, 2*PI)))
				
				print(all[0].stamina)
				if all[i].stamina >= splitThreshold:
					all[i].split_lucas()
		
	
	
	# Update Luca's position

#func move():
		# Generate random velocity
	
	#self.global_position += Vector2(randf_range(-5, 5), randf_range(-5, 5))

func split_lucas():

	# Spawn two new lucas instances
	
	var scene = preload("res://luca.tscn")
	var luca = scene.instantiate()
	self.stamina -= splitThreshold
	#luca.stamina -= splitThreshold
	
	self.get_node("RigidBody2D").set_collision_layer_value(2, false)
	self.get_node("RigidBody2D").set_collision_mask_value(2, false)
	self.get_node("RigidBody2D").set_collision_layer_value(1, true)
	self.get_node("RigidBody2D").set_collision_mask_value(1, true)
	
	add_sibling(luca)
	all.append(luca)

	if luca.get_node("RigidBody2D") != null:
		luca.get_node("RigidBody2D").set_collision_layer_value(2, true)
		luca.get_node("RigidBody2D").set_collision_mask_value(2, true)
		luca.get_node("RigidBody2D").set_collision_layer_value(1, false)
		luca.get_node("RigidBody2D").set_collision_mask_value(1, false)
		
		
		print("HELLO")
		
	#get_tree().create_timer(randf_range(spawn_interval_min, spawn_interval_max))
