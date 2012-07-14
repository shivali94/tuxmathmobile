package ;

import nme.Lib;
import nme.media.Sound;
import nme.Assets;

/**
 * ...
 * @author Deepak Aggarwal
 */

class GameConstant 
{
	public static var no_of_question:Int = 20;
	public static var level_time = 150000;					// Level time   - 2.5 minutes 
	
	// Used for calculating numbers of star which a player get in sublevel
	public static var star_3 = 1800;
	public static var star_2 = 1500;
	public static var star_1 = 1200;
	public static var stageWidth:Int;
	public static var stageHeight:Int;
	
	public static var background_sound:Sound;
	public static var space_travel:Sound;
	public static var transition_end:Sound;
	public static function initialize()
	{
		// stageWidth and stage height
		#if (iphone)
			// Width and Height of stage are swapped in IOS 
			stageWidth = Lib.current.stage.stageHeight;
			stageHeight = Lib.current.stage.stageWidth;
		#else
			stageWidth = Lib.current.stage.stageWidth;
			stageHeight = Lib.current.stage.stageHeight;
		#end 
		
		background_sound = Assets.getSound("assets/sounds/background.mp3");
		space_travel = Assets.getSound("assets/sounds/space_travel.mp3");
		transition_end = Assets.getSound("assets/sounds/transition_end.mp3");
	}
}