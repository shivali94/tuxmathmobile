package ;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.geom.Rectangle;
import nme.Lib;
import nme.text.TextField;
import nme.utils.Timer;
import nme.events.TimerEvent;
import nme.events.MouseEvent;

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
	private var numButtton:Console;					// Used for handling number button will will also be used for updating console screen 
	public var laserValue:Int;
	private var timer:Timer;
	public function new() 
	{
		super();
		laserValue = 0;
		background = new Background(this);             // passing my reference 
		addChild(background);
		asteroid = new AsteroidContainer(this);
		addChild(asteroid);								// Adding main asteroid sprite which will contain all asteroids 
		timer = new Timer(12000,10);
		timer.addEventListener(TimerEvent.TIMER,generateAsteroid);
		timer.start();
		addChild(new Spaceship());
		numButtton = new Console(); 
		//numButtton.addEventListener(TouchEvent.TOUCH_BEGIN, handleNumButton);
		numButtton.addEventListener(MouseEvent.MOUSE_DOWN, handleNumButton);
		addChild(numButtton);
	}
	// This function will be responsibe for receving and handling number buttons 
	public function handleNumButton (ev:Event)
	{
		if (Std.is(ev.target,TextField))
			laserValue = laserValue * 10 + ev.target.parent.value;
		else
			laserValue = laserValue * 10 + ev.target.value;
		if (asteroid.attackAsteroid() == true)
			laserValue = 0;
		if (laserValue > 10)
			laserValue = 0;							//Reseting Laser value
		numButtton.updateConsoleScreen("0" + laserValue);
	}
	
	public function generateAsteroid(ev:TimerEvent)
	{
		asteroid.addAsteroid(Math.floor(Math.random() * 10), Math.floor(Math.random() * 10), ArithmeticOperation.sum);
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