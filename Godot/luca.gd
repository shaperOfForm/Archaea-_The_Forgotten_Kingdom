class_name Luca
extends RigidBody2D

static var all: Array = []

@onready var collision_shape: CollisionShape2D = self.get_node("CollisionShape2D")
@onready var sprite: Sprite2D

# Exported properties
@export var maxStamina: float = 100.0
@export var splitThreshold: float = 80.0
@export var speed: float = 200
var life_span: float = 200.0

@export var exportedCapsuleRadius: float = 500.0
@export var exportedCapsuleHeight: float = 500.0

#@onready var range_area_size = $CollisionShape2D.shape.set_radius(radius)
@onready var radius: float = collision_shape.shape.radius
@export var rad = radius;

#@onready var capsuleRadius: float setget set_capsule_radius
#ar capsuleHeight: float setget set_capsule_height

var acceleration: Vector2
var stamina: float
var split_timer: int



func _init():
	# Initialize stamina
	self.stamina = 0.0
	self.life_span = 200.0
	Luca.all.append(self)

func _ready():
	
	#set_radius(radius)
	radius = collision_shape.shape.radius
	
	print(radius)
	#capsuleRadius = exportedCapsuleRadius
	#capsuleHeight = exportedCapsuleHeight

#func set_capsule_radius(value):
	#capsuleRadius = value
	#if collision_shape and collision_shape.shape:
	#	collision_shape.shape.radius = value

#func set_capsule_height(value):
#	capsuleHeight = value
#	if collision_shape and collision_shape.shape:
#		collision_shape.shape.height = value

func _process(delta: float):
	#sprite.scale = Vector2(radius, height / 2)
	# Update stamina
	self.stamina += delta * 20.0  # Adjust the rate as needed
	if self.stamina > maxStamina:
		self.stamina = maxStamina
	
	self.life_span -= delta * 20.0
	
	#var text_box = get_node("%life_span_text")
	#text_box.text = str(self.life_span)

func _physics_process(_delta):
	pass

func _integrate_forces(state):
	# Apply acceleration
	self.linear_velocity += self.acceleration * state.get_step()
	# Reset acceleration
	self.acceleration = Vector2.ZERO

func set_radius(value):
	radius = value
	if collision_shape and collision_shape.shape:
		collision_shape.shape.radius = value
		return value

func die():
	var lucaSprite = self.get_node("luca_sprite")
	var animationPlayer = self.get_node("AnimationPlayer")  # Replace with the actual path to your AnimationPlayer node
	animationPlayer.play("die")  # Replace with the actual name of your animation

#func set_height(value):
#	height = value
#	if collision_shape and collision_shape.shape:
#		collision_shape.shape.height = value

func _on_body_entered(otherBody:Node):
	print("Collision with " + otherBody.name)
	# get otherBody parent
	
	if otherBody is Luca:
		# get the other Luca
		var otherLuca = otherBody as Luca
		# add force to self away from otherLuca
		#var direction = self.global_position - otherLuca.global_position
		# set impulse
		#self.apply_impulse(self.global_position, direction.normalized() * speed)
	elif otherBody.name == "World Boundary":
		self.linear_velocity = Vector2(0, 0)
