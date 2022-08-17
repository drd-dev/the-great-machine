extends Node

func _ready():
	Update_Music();

func Update_Music():
	if(GameManager.game_state == GameManager.DRILLING):
		$Digging_Music.playing = true;
		$Exploring_Music.playing = false;
		$Menu_Music.playing = false;
	elif(GameManager.game_state == GameManager.EXPLORING):
		$Digging_Music.playing = false;
		$Exploring_Music.playing = true;
		$Menu_Music.playing = false;
	elif(GameManager.game_state == GameManager.IDLE):
		$Digging_Music.playing = false;
		$Exploring_Music.playing = false;
		$Menu_Music.playing = false;
	elif(GameManager.game_state == GameManager.MENU):
		$Digging_Music.playing = false;
		$Exploring_Music.playing = false;
		$Menu_Music.playing = true;

func Drill_SFX():
	$Drill_SFX.play();

func AirLock_Ready_SFX():
	$AirLock_Ready.play();
	
func Gold_Colelcted_SFX():
	$Gem_Collected.play();
	
	
func Rock_Destroyed_SFX():
	$RockDestroyed.play()

func Slime_killed_SFX():
	$EnemyKilled.play();
	
func Button_SFX():
	$ButtonPress.play();

func PickUp_Axe_SFX():
	$PickupAxe.play();
