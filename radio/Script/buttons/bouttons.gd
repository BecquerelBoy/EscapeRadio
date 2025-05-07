extends Control

@onready var yes = $Yes
@onready var no = $No
@onready var click = $Click

var previous_pause_state := false

func _ready() -> void:
	_update_buttons_state()
	previous_pause_state = Global.is_pausing

func _process(_delta: float) -> void:
	if Global.is_pausing != previous_pause_state:
		_update_buttons_state()
		previous_pause_state = Global.is_pausing

func _update_buttons_state() -> void:
	var disabled := Global.is_pausing
	yes.disabled = disabled
	no.disabled = disabled

func _on_yes_pressed() -> void:
	if yes.disabled:
		return
	click.play()
	var next = Global.current_text * 2
	Global.afficher_texte_par_numero(next)

func _on_no_pressed() -> void:
	if no.disabled:
		return
	click.play()
	var next = Global.current_text * 2 + 1
	Global.afficher_texte_par_numero(next)
