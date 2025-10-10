extends Panel

func setup(texture_path: String):
	var texture = load(texture_path)
	var styleBox = StyleBoxTexture.new()
	styleBox.texture = texture
	add_theme_stylebox_override("panel", styleBox)
