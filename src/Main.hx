package ;

import nme.display.Shape;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.events.Event;
import nme.display.FPS;
/**
 * ...
 * @author Deepak Aggarwal
 */

class Main 
{
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
				var rectangle:Shape = new Shape(); // initializing the variable named rectangle
		var temp = new Level();
		temp.play();
		Lib.current.addChild(temp);
		
		
		// Code for displaying FPS on android screen
		rectangle.graphics.beginFill(0xFFFFFF); // choosing the colour for the fill, here it is red
		rectangle.graphics.drawRect(0, 0, 80,40); // (x spacing, y spacing, width, height)
		rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
		Lib.current.addChild(rectangle); // adds the rectangle to the stage
		Lib.current.addChild(new FPS());
	}
	
}