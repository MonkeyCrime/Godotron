class_name Enums

enum UnitType {
	PLAYER,
	PLAYER_BULLET,
	GRUNT,
	HULK,
	BRAIN,
	ENFORCER,
	ENFORCER_BULLET,
	SPHEROID,
	TANK,
	ELECTRODE,
	FAMILY,
}

enum UnitState {
	INITIALISING,
	ACTIVE,
	DEAD
}

enum ShotDirection {
	NORTH,
	NORTH_EAST,
	EAST,
	SOUTH_EAST,
	SOUTH,
	SOUTH_WEST,
	WEST,
	NORTH_WEST
}

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

enum FamilyMember {
	DADDY,
	MUMMY,
	MIKEY
}

enum GruntMoveMode {
	DELAY_START,
	STANDING,
	MOVING
}
