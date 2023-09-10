class_name Constants

const EVENT_ENEMY_HIT: StringName = "enemy_hit"
const EVENT_ENEMY_DEAD: StringName = "enemy_dead"
const EVENT_GAME_OVER: StringName = "game_over"
const EVENT_PLAYER_ENTRY_COMPLETE: StringName = "player_enter_level_complete"
const EVENT_PLAYER_EXIT_COMPLETE: StringName = "player_exit_level_complete"
const EVENT_PLAYER_INVULNERABLE: StringName = "player_invulnerable"
const EVENT_PLAYER_HIT: StringName = "player_hit"
const EVENT_PLAYER_RESCUE_FAMILY: StringName = "player_rescue_family"
const EVENT_PLAYER_ADD_LIVES: StringName = "player_add_lives"
const EVENT_PLAYER_PLAY_BONUS: StringName = "player_play_bonus"
const EVENT_UNITS_SPAWNED: StringName = "units_spawned"
const EVENT_UNITS_IDLE: StringName = "units_idle"
const EVENT_UNITS_ACTIVATED: StringName = "units_activated"
const EVENT_LEVEL_COMPLETE: StringName = "level_complete"
const EVENT_TRANSITION_INTRO_COMPLETE: StringName = "transition_intro_complete"
const EVENT_TRANSITION_OUTRO_COMPLETE: StringName = "transition_outro_complete"
const EVENT_UI_INITIALISE: StringName = "ui_initialise"
const EVENT_UI_UPDATE_LIVES: StringName = "ui_update_lives"
const EVENT_UI_UPDATE_WAVE: StringName = "ui_update_wave"
const EVENT_UI_UPDATE_POINTS: StringName = "ui_update_points"
const EVENT_SPAWN_ENEMY: StringName = "spawn_enemy"

const METHOD_UNIT_HIT: StringName = "on_unit_hit"

const WALK_DIRECTIONS = [
	Vector2(0,  -1),
	Vector2(1,   0),
	Vector2(0,   1),
	Vector2(-1,  0)
]

const SCENE_PLAYER: String = "res://scenes/player/player.tscn"
const SCENE_GRUNT: String = "res://scenes/grunt/grunt.tscn"
const SCENE_HULK: String = "res://scenes/hulk/hulk.tscn"
const SCENE_MAIN_MENU: String = "res://scenes/main_menu/main_menu.tscn"
const SCENE_BULLET: String = "res://scenes/bullet/bullet.tscn"
const SCENE_ELECTRODE: String = "res://scenes/electrode/electrode.tscn"
const SCENE_SPHEROID: String = "res://scenes/spheroid/spheroid.tscn"
const SCENE_ENFORCER: String = "res://scenes/enforcer/enforcer.tscn"
const SCENE_ENFORCER_BULLET: String = "res://scenes/enforcer/bullet/enforcer_bullet.tscn"
const SCENE_FAMILY: String = "res://scenes/family/family.tscn"
const LEVEL_STARTER: String = "res://level_data.json"
const LEVEL_ENDLESS: String = "res://level_data_endless.json"

const SPAWN_MIN_DISTANCE: float = 0.4
const SPAWN_MAX_DISTANCE: float = 0.9
const SPAWN_MAX_GRUNTS: int = 50
const SPAWN_MAX_HULKS: int = 30
const SPAWN_MAX_ELECTRODES: int = 30
const SPAWN_MAX_SPHEROIDS: int = 10
const SPAWN_MAX_ENFORCERS: int = 10
const SPAWN_MAX_ENFORCER_BULLETS: int = 20
const SPAWN_MAX_FAMILY: int = 20

const UI_LIVES_OFFSET: int = 24
const UI_LIVES_SPACING: int = 12

const ANIM_ELECTRODE_NAME: StringName = "electrode_%d"
const ANIM_ELECTRODE_MIN: int = 1
const ANIM_ELECTRODE_MAX: int = 5
const ANIM_SPHEROID_NAME: StringName = "active"

const POINTS_GRUNT: int = 100
const POINTS_ELECTRODE: int = 25
const POINTS_SPHEROID: int = 150
const POINTS_ENFORCER: int = 200
const POINTS_FAMILY: int = 1000

const SPEED_SPHEROID: int = 250
const SPEED_ENFORCER: int = 300
const SPEED_GRUNT: int = 150
const SPEED_HULK: int = 75
const SPEED_FAMILY: int = 50
const SPEED_ENFORCER_BULLET: int = 175

const ENFORCER_MIN_FIRETIME: int = 1
const ENFORCER_MAX_FIRETIME: int = 2

const GRUNT_RANDOM_WAITTIME: float = 0.5

const FAMILY_WALK_MIN: int = 2
const FAMILY_WALK_MAX: int = 4

const HULK_WALK_MIN: float = 2.0
const HULK_WALK_MAX: float = 5.0
const HULK_KNOCKBACK:int = 10

const SPHEROID_SPAWNTIME_MIN: int = 2
const SPHEROID_SPAWNTIME_MAX: int = 4

const GROUPNAME_PLAYER: StringName = "Player"
const GROUPNAME_ENEMIES: StringName = "Enemies"
const GROUPNAME_ENVIRONMENT: StringName = "Environment"
const GROUPNAME_WALLS: StringName = "Walls"
const GROUPNAME_FAMILY: StringName = "Family"

const STATENAME_IDLE: StringName = "Idle"
const STATENAME_ACTIVE: StringName = "Active"
const STATENAME_EXITLEVEL: StringName = "ExitLevel"
const STATENAME_ENTERLEVEL: StringName = "EnterLevel"
const STATENAME_TRAVELLING_WALL: StringName = "TravellingToWall"

const COLLISION_MASK_PLAYER: int = 2
const COLLISION_MASK_PLAYER_SHOTS: int = 3
