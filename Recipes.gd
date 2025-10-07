class_name Recipes

const meshes:Dictionary = {
	Enum.RecipeNames.Tom : preload("res://assets/blender/Tomato.blend"),
	Enum.RecipeNames.CutTom : preload("res://assets/blender/CutTomato.blend"),
	Enum.RecipeNames.PotCutTom : preload("res://assets/blender/TomSoup1.blend"),
	Enum.RecipeNames.PotCutTomCutTom : preload("res://assets/blender/TomSoup2.blend"),
	Enum.RecipeNames.PotCutTomCutTomCutTom : preload("res://assets/blender/TomSoup3.blend"),
	Enum.RecipeNames.TomatoSoup : preload("res://assets/blender/TomSoup.blend"),
}

static func recipeToMesh(recipe:Enum.RecipeNames) -> PackedScene:
	if(meshes.has(recipe)): return meshes[recipe]
	return null

static func recipesMix(recipe:Enum.RecipeNames, ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match recipe:
		Enum.RecipeNames.PotCutTom:
			match ingredient:
				Enum.RecipeNames.CutTom:
					return Enum.RecipeNames.PotCutTomCutTom
		Enum.RecipeNames.PotCutTomCutTom:
			match ingredient:
				Enum.RecipeNames.CutTom:
					return Enum.RecipeNames.PotCutTomCutTomCutTom
		Enum.RecipeNames.Empty:
			return ingredient
	return Enum.RecipeNames.Empty

static func recipesCut(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.Tom:
			return Enum.RecipeNames.CutTom
	return Enum.RecipeNames.Empty
	
static func recipesPot(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.CutTom:
			return Enum.RecipeNames.PotCutTom
	return Enum.RecipeNames.Empty

static func recipesCook(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.PotCutTomCutTomCutTom:
			return Enum.RecipeNames.TomatoSoup
	return Enum.RecipeNames.Empty
	
