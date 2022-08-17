extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	$Gold_Count.text = String(GameManager.gold_collected);
	if(GameManager.player != null):
		$Health_UI.frame = GameManager.player.health;
		get_node("oxygen/oxygen_levels").text = String(GameManager.player.current_oxygen);
		if(GameManager.player.health <= 0):
			$DeathMenu.visible = true;
	
	$debugInfo.text = "Game State:" + String(GameManager.game_state);
	


func _on_TextureButton_pressed():
	GameManager.player = null
	GameManager.game_state = GameManager.MENU
	AudioManager.Update_Music();
	AudioManager.Button_SFX();
	LevelManager.load_level("MainMenu")
	GameManager.gold_collected = 0;
	TintManager.Clear_Tint();
	pass # Replace with function body.
