package ;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.geom.Rectangle;
import nme.Lib;
import nme.text.TextField;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Level extends Sprite
{
	private var oldtime:Int;
	public  var diffTime:Int ;                   // Used for scrolling window and animating other things
	private var background:Background;
	private var asteroid:AsteroidContainer;
	private var numButtton:NumButton;
	
	public function new() 
	{
		super();
		background = new Background(this);             // passing my reference 
		addChild(background);
		asteroid = new AsteroidContainer(this);
		addChild(asteroid);								// Adding main asteroid sprite which will contain all asteroids 
		asteroid.addAsteroid("2+5");
		addChild(new Spaceship());
		numButtton = new NumButton(); 
		numButtton.addEventListener(TouchEvent.TOUCH_BEGIN, handleNumButton);
		addChild(numButtton);
	}
	
	// This function will be responsibe for receving and handling number buttons 
	public function handleNumButton (ev:TouchEvent)
	{
		if (Std.is(ev.target,TextField))
			trace("Button pressed is:" + ev.target.parent.value);
		else
			trace("Button pressed is:" + ev.target.value);
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