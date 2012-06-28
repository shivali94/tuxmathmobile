package ;
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

class Spaceship extends Sprite
{
	var line:Shape;
	var spaceship:Bitmap;
	public function new() 
	{
		super();
		spaceship = new Bitmap(Assets.getBitmapData("assets/spaceship/spaceship.png"));
		spaceship.y = (Lib.current.stage.stageHeight - spaceship.height) / 2;
		addChild(spaceship);
	}
	public function show_laser(x:Float,y:Float)
	{
		var line:Shape = new Shape();
		line.graphics.lineStyle(4, 0xFF0000);
		line.graphics.moveTo(spaceship.x + spaceship.width,spaceship.y + spaceship.height/2);
		line.graphics.lineTo(x, y);
		addChildAt(line,1);
		Timer.delay(function() { removeChild(line); }, 50);
	}

}