package ;

import nme.Lib;
import nme.events.Event;
import nme.Assets;
/**
 * ...
 * @author Deepak Aggarwal
 */

class Game 
{
	var level_instance:Level;
	var menu_handler:MenuHandler;
	
	private function calculate_score()
	{
		// 500 for speed points 
		var speed:Int  = cast (level_instance.stats.player_speed / GameConstant.no_of_question) * 250;    
		var accuracy:Int  = cast (level_instance.stats.wrong_attempts * ( -25)) + 250;
		if (accuracy < 0)										// Score can't be negetive 
			accuracy = 0;		
		var answered:Int = cast (level_instance.stats.total_question_answered / GameConstant.no_of_question) * 1500;
		return ({speed:speed,accuracy:accuracy,answered:answered});
	}
	
	// It will be responsible for loading main screen which will show all levels and sublevel with their corresponding star
	public function mainGameScreen()
	{
		//This should be done first so that initial loading time is low 
		Lib.current.addChild(menu_handler);
		menu_handler.addEventListener("Start Game",startGame);
		level_instance.addEventListener("Game Complete",gameComplete);
	}
	
	function startGame(ev:Event){
		// +1 because values are starting from 0
		level_instance.initialize(menu_handler.level+1, menu_handler.sublevel+1);
		Lib.current.addChild(level_instance);
		level_instance.play();
		Lib.current.removeChild(menu_handler);
	}
	
	function gameComplete(ev:Event) {
		var temp = calculate_score();
		var total_score = temp.accuracy + temp.answered + temp.speed;
		if (total_score >= GameConstant.star_3)
			SavedData.storeData(menu_handler.level, menu_handler.sublevel, 3);
			else if (total_score >= GameConstant.star_2)
				SavedData.storeData(menu_handler.level, menu_handler.sublevel, 2);
				else if (total_score >= GameConstant.star_1)
					SavedData.storeData(menu_handler.level, menu_handler.sublevel, 1);
					else
						SavedData.storeData(menu_handler.level, menu_handler.sublevel, 0);
			
		Lib.current.removeChild(level_instance);
		Lib.current.addChild(menu_handler);
	}
	
	public function new() 
	{
		level_instance = new Level();
		menu_handler = new MenuHandler();
		SavedData.initialize();
		mainGameScreen();
	}
	
}