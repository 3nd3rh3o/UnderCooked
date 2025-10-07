class_name Enum

enum IngType {TOMATO}
enum IngState { RAW, CUT , COOKED}
enum Order { NONE, USE , STORE, UNSTORE, PICKUP}
enum TaskType {NONE, CUT, COOK, STORE, GENERATE_TOMATO, PICKUP, POT, SERVE}
enum RecipeNames {Empty, 
Tom, CutTom, PotCutTom, PotCutTomCutTom, PotCutTomCutTomCutTom, TomatoSoup}

static func IngToString(ingState:IngState, ingType:IngType) -> String:
	return IngState.keys()[ingState] + IngType.keys()[ingType]
