shader_type canvas_item;

uniform float brightness_multiplier : hint_range(1.0, 3.0) = 1.5;
uniform float transition_speed : hint_range(0.1, 10.0) = 5.0;
uniform bool is_hovered = false;

varying float current_brightness;

void vertex() {
    // Calculer la luminosité actuelle basée sur l'état hover
    float target_brightness = is_hovered ? brightness_multiplier : 1.0;

    // Transition fluide vers la luminosité cible
    current_brightness = mix(1.0, target_brightness,
        smoothstep(0.0, 1.0, sin(TIME * transition_speed) * 0.5 + 0.5));
}

void fragment() {
    // Obtenir la couleur de base de la texture
    vec4 base_color = texture(TEXTURE, UV);

    // Appliquer l'éclaircissement
    vec3 brightened_color = base_color.rgb * (is_hovered ? brightness_multiplier : 1.0);

    // Conserver l'alpha original
    COLOR = vec4(brightened_color, base_color.a);
}