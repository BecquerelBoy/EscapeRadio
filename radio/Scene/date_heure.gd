extends Control

@onready var label_date: Label = $date
@onready var label_heure_dizaine: Label = $heure_dizaine
@onready var label_heure_unite: Label = $heure_unite
@onready var label_minute_dizaine: Label = $minute_dizaine
@onready var label_minute_unite: Label = $minute_unite

func _ready():
	var now = Time.get_datetime_dict_from_system()

	# --- Date au format Mois:Jour ---
	var jour = str(now["day"]).pad_zeros(2)
	var mois_index = now["month"]
	var mois_noms = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var mois_abbr = mois_noms[mois_index - 1]
	label_date.text = mois_abbr + " " + jour

	# --- Heure (HH:MM) en chiffres séparés ---
	var heure = str(now["hour"]).pad_zeros(2)
	var minute = str(now["minute"]).pad_zeros(2)

	label_heure_dizaine.text = heure[0]
	label_heure_unite.text = heure[1]
	label_minute_dizaine.text = minute[0]
	label_minute_unite.text = minute[1]
