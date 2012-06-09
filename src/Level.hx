package ;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Level extends Sprite
{
	private var oldtime:Int;
	public  var diffTime:Int ;                   // Used for scrolling window and animating other things
	private var background:Background;
	private var asteroid:Asteroid;
	
	public function new() 
	{
		super();
		background = new Background(this);             // passing my reference 
		addChild(background);
		asteroid = new Asteroid(this);
		addChild(asteroid);								// Adding main asteroid sprite which will contain all asteroids 
		asteroid.addAsteroid();
		loadSpaceship();
	}
	public function loadSpaceship()
	{
		var spaceship:Bitmap = new Bitmap(Assets.getBitmapData("assets/spaceship/spaceship.png"));
		spaceship.y = (Lib.current.stage.stageHeight - spaceship.height) / 2;
		addChild(spaceship);
	}
	public function play()
	{
		oldtime = Lib.getTimer();                                        // Don't use in constructor else you may notice weird behaviour 
		
		addEventListener(Event.ENTER_FRAME, animate);
	}
	
	private function animate(event:Event):Void
	{
		diffTime= Lib.getTimer() - oldtime;
		oldtime += diffTime;
		background.scrollBackground();
		asteroid.handleAsteroid();
	}
	
}