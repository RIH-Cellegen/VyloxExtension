
@tool
@icon("res://addons/Vylox Extension/Classes/VCharacter2D/VCharacter2D.svg")
extends VScript
class_name VCharacter2D

## A feature-rich Character class, containing custom velocity, game values and options
## for different categories of Character options. VCharacter2D


enum enum_character2d_option {None, Platformer, TopDown, Vehicle, WorldObject}
# character_option:
## [b]Choose your character's style with this option![/b]
var character_option: int = 0:
    set(value):
        character_option = value
        character_option = clamp(character_option, 0, enum_character2d_option.keys().size())

enum enum_character2d_gravity {Stable, Increasing, Delta}
# character_gravity:
## [b]Choose one of your character's gravity variations![/b]
## [br]
## [b]Stable:[/b] Gravity Force always will be a stable value and doesn't require limit.
## [br]
## [b]Increasing:[/b] Gravity Force will be an increasing value. The more time Gravity Force
## is active, the faster it gets, till it hits the limit.
## [br]
## [b]Delta[/b] Unlike Stable, Gravity Force will be devided by the Delta amount, requried
## to have the Character reach that velocity every second, the intented amount for Delta.
var character_gravity: int = 0:
    set(value):
        character_gravity = value
        character_gravity = clamp(character_gravity, 0, enum_character2d_gravity.keys().size())

# tile_size:
## [b]The amount for this variable represents pixels and the other variables will scale from this value.[/b]
## [br]
## Setting this variable to 0 causes all of the variables which scale from [b]Tile Size[/b] to become 0 as well!
var tile_size: int = 0:
    set(value):
        tile_size = value
        tile_size = clamp(tile_size, 0, 128)

# limit_velocities:
## [b]Toggles access for all velocity limit list![/b]
## [br]
## If a velocity's limit is 0, then that velocity is uncapped, being able to scale infinitely.
## [br]
## Otherwise a velocity's limit is above 0, then that velocity is capped with the value.
var limit_velocities: bool:
    set(value):
        limit_velocities = value

# platformer_gravity_direction:
## [b]It controls the direction of the Character's Gravity![/b]
## [br]
## The Gravity's calculation will impact the Total Velocity in a way, that all velocity values
## which apply to Total Velocity will be scaled from Gravity Direction, being able to change
## the X and Y axis of the Total Velocity based on Gravity Direction.
## [br]
## This variable won't conflict other Objects' Gravity, or other Objects won't affect this
## variable: [b]It runs independantly from other Objects' gravities.[/b]
var gravity_direction: Vector2:
    set(value):
        gravity_direction = value
        gravity_direction = clamp_vector2(gravity_direction, -1, 1)
        # In case there is no direction, it returns to the default gravity direction.
        # (Down Straight Gravity)
        if gravity_direction == Vector2(0,0):
            printerr("Error with VCharacter2D: No Gravity Direction value set. This results in VCharacter2D not moving with all velocities.")

# platformer_velocity:
## This variable is responsible for gathering all of the available Platformer Velocities
## into Platformer Velocity and applying this variable onto the Character's Position.
var velocity: Vector2:
    set(value):
        velocity = value

var walk_velocity: Vector2:
    set(value):
        walk_velocity = value
        if limit_velocities and walk_limit != 0:
            walk_velocity = clamp_vector2(velocity, -walk_limit, walk_limit)
var run_velocity: Vector2:
    set(value):
        run_velocity = value
        run_velocity = clamp_vector2(velocity, -run_limit, run_limit)

var crouch_velocity: Vector2:
    set(value):
        crouch_velocity = value
        if limit_velocities and crouch_limit != 0:
            crouch_velocity = clamp_vector2(velocity, -crouch_limit, crouch_limit)

var jump_velocity: Vector2:
    set(value):
        jump_velocity = value
        if limit_velocities and jump_limit != 0:
            jump_velocity = clamp_vector2(
            velocity,
            -jump_limit * tile_size,
            jump_limit * tile_size
            )
var gravity_velocity: Vector2:
    set(value):
        gravity_velocity = value
        gravity_velocity = clamp_vector2(
        velocity,
        -gravity_limit,
        gravity_limit
        )
var walljump_velocity: Vector2:
    set(value):
        walljump_velocity = value
        if limit_velocities and walljump_limit != 0:
            walljump_velocity = clamp_vector2(
            velocity,
            -walljump_limit * tile_size,
            walljump_limit * tile_size
            )
var slide_velocity: Vector2:
    set(value):
        slide_velocity = value
        if limit_velocities and slide_limit != 0:
            slide_velocity = clamp_vector2(
            velocity,
            -slide_limit * tile_size,
            slide_limit * tile_size
            )
var glide_velocity: Vector2:
    set(value):
        glide_velocity = value
        if limit_velocities and glide_limit != 0:
            glide_velocity = clamp_vector2(
            velocity,
            -glide_limit * tile_size,
            glide_limit * tile_size
            )
var dash_velocity: Vector2:
    set(value):
        dash_velocity = value
        if limit_velocities and dash_limit != 0:
            dash_velocity = clamp_vector2(
            velocity,
            -dash_limit * tile_size,
            dash_limit * tile_size
            )

# platformer_velocity_limit:
## This value limits the Total Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var velocity_limit: int
# platformer_walk_limit:
## This value limits the Walking Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var walk_limit: int
# platformer_run_limit:
## This value limits the Running Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var run_limit: int
# platformer_crouch_limit:
## This value limits the Crouching Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var crouch_limit: int
# platformer_jump_limit:
## This value limits the Jumping Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var jump_limit: int
# platformer_gravity_limit:
## This value limits the Gravity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var gravity_limit: int
# platformer_walljump_limit:
## This value limits the Walljump Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var walljump_limit: int
# platformer_slide_limit:
## This value limits the Sliding Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var slide_limit: int
# platformer_glide_limit:
## This value limits the Gliding Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var glide_limit: int
# platformer_dash_limit:
## This value limits the Dashing Velocity of the player on both X and Y axis.
## [br]
## If the value is 0, the velocity is uncapped.
var dash_limit: int

# enable_gravity:
## [b]Toggle Access to Gravity for the character![/b]
## [br]
## It allows you to manipulate both the direction and the strength of the character's
## gravity, not dependently from other Objects.
## [br]
## It can also change the complexity of the Gravity, which will give you more options
## to tinker for the character.
var enable_gravity: bool

# platformer_gravity_force:
## [b]Apply a stable value for Gravity every frame![/b]
## [br]
## Stable Value means that it won't increase every frame, but always has the same value to apply.
## This value cannot go below 0 or above it's recommended limit. It must have a value within 0 and the maximum amount if
## Gravity is enabled.
var gravity_force: float = 0:
    set(value):
        gravity_force = value
        gravity_force = clamp(gravity_force, 0, 20)

var gravity_multiplier: float = 0:
    set(value):
        gravity_multiplier = value
        gravity_multiplier = clamp(gravity_multiplier, 0, 1)

var gravity_build_up_on_floor: bool = 0

var is_on_floor: bool
var is_on_wall: bool
var is_below_platform: bool
var is_on_air: bool



func _get_property_list():
    var Inspector = VInspector.new()
    
    Inspector.create_enum("character_option", enum_character2d_option)
    
    if character_option == enum_character2d_option.Platformer:
        Inspector.create_group("General Options")
        Inspector.create_float("tile_size", 0, 128)
        
        Inspector.create_group("yes")
        
        Inspector.create_group("Permissions")
        
        Inspector.create_group("Movement Options")
        
        Inspector.create_group("Gravity")
        Inspector.create_bool("enable_gravity")
        Inspector.create_vector2("gravity_direction")
        Inspector.create_enum("character_gravity", enum_character2d_gravity)
        if character_gravity == enum_character2d_gravity.Stable:
            Inspector.create_float("gravity_force", 0, 20)
        if character_gravity == enum_character2d_gravity.Increasing:
            Inspector.create_float("gravity_multiplier", 0, 1, 0.01)
            Inspector.create_float("gravity_limit", 0, 50)
        Inspector.create_bool("gravity_build_up_on_floor")
        
        Inspector.create_group("Walking")
        Inspector.create_group("Running")
        Inspector.create_group("Crouching")
        Inspector.create_group("Jumping")
        Inspector.create_group("Walljumping")
        Inspector.create_group("Sliding")
        Inspector.create_group("Gliding")
        Inspector.create_group("Dashing")
    
    return Inspector.properties

func platformer_gravity(complexity: int, force: float, limit: int, direction: Vector2):
    
    gravity_velocity.x += force * direction.x
    gravity_velocity.y += force * direction.y
    
    if limit != 0:
        gravity_velocity.x = clamp(gravity_velocity.x, -limit, limit)
        gravity_velocity.y = clamp(gravity_velocity.y, -limit, limit)
    return gravity_velocity

func platformer_total_velocity(
    total_vel: Vector2,
    gravity_vel: Vector2,
    walk_vel: Vector2,
    jump_vel:= Vector2(),
    run_vel:= Vector2(),
    crouch_vel:= Vector2(),
    walljump_vel:= Vector2(),
    slide_vel:= Vector2(),
    glide_vel:= Vector2(),
    dash_vel:= Vector2()
    ):
    pass

func _physics_process(delta):
    
    
    
    
    if !Engine.is_editor_hint():
        
        if character_option == enum_character2d_option.Platformer:
            if enable_gravity:
                platformer_gravity(character_gravity, gravity_force, gravity_limit, gravity_direction)
            self.position += velocity
            
