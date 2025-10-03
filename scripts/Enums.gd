class_name Enum

enum IngType {ONION}
enum IngState { RAW, CUT , COOKED}
enum Order { NONE, USE , STORE, UNSTORE, PICKUP}
enum TaskType {NONE, CUT, COOK, STORE, GENERATE_ONION, PICKUP, POT, SERVE}

static func IngToString(ingState:IngState, ingType:IngType) -> String:
	return IngState.keys()[ingState] + IngType.keys()[ingType]
