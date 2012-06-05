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
	private var nextUpdateTime:Int ;
	private var nextUpdate:Int ;
	private var oldtime:Int;
	public  var diffTime:Int ;                   // Used for scrolling window
	private var background:Background;
	
	public function new() 
	{
		super();
		nextUpdate = 30;				 								// try to update at 30 FPS in order to lower cpu/gpu load 
		background = new Background(this);             // passing my reference 
		addChild(background);
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
		Lib.current.addEventListener(Event.ENTER_FRAME, animate);
	}
	
	private function animate(event:Event):Void
	{
		diffTime= Lib.getTimer() - oldtime;
		if (nextUpdateTime > diffTime)
			return;
		background.scrollBackground();
		nextUpdateTime += nextUpdate;                                    // Incrementing next screen update time 
	}
	
}