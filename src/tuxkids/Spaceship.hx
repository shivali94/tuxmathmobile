package tuxkids;
import nme.display.Shape;
import nme.display.Sprite;
import nme.Assets;
import nme.display.Bitmap;
import nme.Lib;
import haxe.Timer;

/**
 * ...
 * @author Deepak Aggarwal
 */

/**
 * Class for loading spaceship and showing laser.
 */
class Spaceship extends Sprite
{
	// For showing laser.
	var line:Shape;
	// For loading spaceship image.
	var spaceship:Bitmap;
	/**
	 * Constructor
	 */ 
	public function new() 
	{
		super();
		// Loading spaceship image.
		spaceship = new Bitmap(Assets.getBitmapData("assets/spaceship/spaceship.png"));
		// Centering it.
		spaceship.y = (GameConstant.stageHeight - spaceship.height) / 2;
		// Ading it to the stage.
		addChild(spaceship);
	}
	/**
	 * Function used to show laser. <br>
	 * @param	x :- End x co-ordinate
	 * @param	y :- End y co-ordinate
	 */
	public function show_laser(x:Float,y:Float)
	{
		var line:Shape = new Shape();
		line.graphics.lineStyle(4, 0xFF0000);
		line.graphics.moveTo(spaceship.x + spaceship.width,spaceship.y + spaceship.height/2);
		line.graphics.lineTo(x, y);
		addChildAt(line,1);
		Timer.delay(function() { removeChild(line); }, 150);
	}

}