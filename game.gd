extends Node2D

var foreign_letters = ["А", "Б", "В", "Г", "Д", "Ђ", "Е", "Ж", "З", "И", "Ј", "К", "Л", "Љ", "М", "Н", "Њ", "О", "П", "Р", "С", "Т", "Ћ", "У", "Ф", "Х", "Ц", "Ч", "Џ", "Ш"]
var letters = ["A", "B", "V", "G", "D", "Đ", "E", "Ž", "Z", "I", "J", "K", "L", "Lj", "M", "N", "Nj", "O", "P", "R", "S", "T", "Ć", "U", "F", "H", "C", "Č", "Dž", "Š"]
var foreign_letters_small = ["а", "б", "в", "г", "д", "ђ", "е", "ж", "з", "и",	"ј", "к", "л", "љ", "м", "н", "њ", "о", "п", "р", "с", "т", "ћ", "у", "ф", "х", "ц", "ч", "џ", "ш"]
var letters_small = ["a", "b", "v", "g", "d", "đ", "e", "ž", "z", "i", "j", "k", "l", "lj", "m", "n", "nj", "o", "p", "r", "s", "t", "ć", "u", "f", "h", "c", "č", "dž", "š"]
var correct_letter = ""
var new_index = 0 
var previous = 0
@onready var result_label = $ResultLabel
var correct_guesses = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_new_round() # Replace with function body.

func setup_new_round():
	while(new_index == previous):
		new_index = randi() % foreign_letters.size()
	previous = new_index
	correct_letter = foreign_letters[new_index]
	$TargetLetter.text = "Click: " + correct_letter
	
	correct_letter = letters[new_index]
	
	var buttons = [$ButtonContainer/LetterButton1, $ButtonContainer/LetterButton2, $ButtonContainer/LetterButton3, $ButtonContainer/LetterButton4]
	
	# Shuffle and assign letters (ensure one is correct)
	var choices = [letters[new_index]]
	
	while choices.size() < buttons.size():
		var random_letter = letters[randi() % letters.size()]
		if random_letter not in choices:  # Avoid duplicates
			choices.append(random_letter)
	choices.shuffle()
	

	# Assign letters to buttons and connect signals
	for i in range(buttons.size()):
		buttons[i].text = choices[i]
		if buttons[i].is_connected("pressed", Callable(self, "_on_button_pressed")):
			buttons[i].disconnect("pressed", Callable(self, "_on_button_pressed"))
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(buttons[i]))

func _on_button_pressed(button):
	var buttons = [$ButtonContainer/LetterButton1, $ButtonContainer/LetterButton2, $ButtonContainer/LetterButton3, $ButtonContainer/LetterButton4]
	print("Button clicked: ", button.text, " | Correct letter: ", correct_letter)
	if button.text == correct_letter:
		correct_guesses += 1
		print("Correct")
		modulate = Color(0.5, 1, 0.5)
	else:
		correct_guesses = 0
		print("Wrong")
		modulate = Color(1, 0.3, 0.3)
	result_label.text = str(correct_guesses)
	for butt in buttons:
		butt.disabled = true
	$Timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_timer_timeout() -> void:
	$Timer.stop()
	var buttons = [$ButtonContainer/LetterButton1, $ButtonContainer/LetterButton2, $ButtonContainer/LetterButton3, $ButtonContainer/LetterButton4]
	modulate = Color(1, 1, 1)
	for butt in buttons:
		butt.disabled = false
	setup_new_round()


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://home.tscn")
