package ;
import nme.display.Sprite;
import nme.Assets;
import nme.display.Bitmap;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Spaceship extends Sprite
{

	public function new() 
	{
		super();
		var spaceship:Bitmap = new Bitmap(Assets.getBitmapData("assets/spaceship/spaceship.png"));
		spaceship.y = (Lib.current.stage.stageHeight - spaceship.height) / 2;
		addChild(spaceship);
	}
	
}