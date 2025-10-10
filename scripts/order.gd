extends Control

@export var recipe: Recipe
@export var time = Config.ORDER_EXPIRE_TIME
@export var priority = 1
@onready var MainPanel = $Main
@onready var ExpireBar = $Main/ExpireBar
@onready var TexturePanel = $Main/Texture

func set_up():
	size = Vector2(100, 100)
	MainPanel.size = Vector2(100, 100)
	TexturePanel.size = Vector2(100, 100)
	var tex = load(recipe.item.render)
	var styleTex = StyleBoxTexture.new()
	styleTex.texture = tex
	TexturePanel.add_theme_stylebox_override("panel", styleTex)
	ExpireBar.size.x = MainPanel.size.x
	ExpireBar.size.y = 10
	ExpireBar.anchor_top = 1
	ExpireBar.anchor_bottom = 1
	ExpireBar.anchor_left = 0
	ExpireBar.anchor_right = 0
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 1, 0)
	ExpireBar.add_theme_stylebox_override("panel", style)
