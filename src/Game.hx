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
		
	}
	public function new() 
	{
		level_instance = new Level();
		level_instance.initialize(3, 10);
		level_instance.play();
		level_instance.addEventListener("Level Complete", function(ev:Event) {
			var temp=calculate_score();
			Lib.current.removeChild(level_instance);
		});
		Lib.current.addChild(level_instance);
	}
	
}