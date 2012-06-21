package ;

import nme.Lib;
import nme.events.Event;
/**
 * ...
 * @author Deepak Aggarwal
 */

class Game 
{

	public function new() 
	{
		var temp = new Level();
		temp.initialize(3, 10);
		temp.play();
		temp.addEventListener("Level Complete", function(ev:Event) {
			Lib.current.removeChild(temp);
			trace("Level completes");
		});
		Lib.current.addChild(temp);
	}
	
}