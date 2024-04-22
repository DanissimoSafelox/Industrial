shader_type canvas_item;
/*Здесь вообще C++, так что не совсем понимаю, чо тут. Открываем гайд godot action rpg series  и смотрим P22*/
/*И вообще, мне просто нужно состояние белого и обычного спрайта (переключатель)*/
uniform bool active = false;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	vec4 new_color = previous_color;
	if (active == true) {
		new_color = white_color;
	}
	COLOR = new_color;
}