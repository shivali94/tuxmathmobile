package ;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Asteroid extends Sprite 
{
	var asteroid:Bitmap;
	var deltaMovement:Float;
	var level:Level; 
	var asteroidSpeed:Float;
	public function new(level_instance:Level) 
	{
		super();
		this.level = level_instance;
		deltaMovement = 0.02;
		loadAsteroid();
	}
	public function loadAsteroid():Void 
	{
		asteroid = new Bitmap(Assets.getBitmapData("assets/asteroid/asteroid.png"));
	}
	public function addAsteroid()
	{
		asteroid.x = Lib.current.stage.stageWidth + 10;                                 // Start scrolling asteroid from the right side of the screen 
		asteroid.y = 130;
		asteroidSpeed = deltaMovement *1.2;
		addChild(asteroid);
	}
	public function handleAsteroid()						// This function will be responsible for updating and destroying asteroid 
	{
		asteroid.x -= level.diffTime*asteroidSpeed;
	}
	
}