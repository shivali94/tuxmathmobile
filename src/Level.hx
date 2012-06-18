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
	private var asteroid_timer:Timer;
	static  var level_time:Int=120000;						// Level time 
	public  var level_timer:Timer;							// Timer for automatically end level;
	public function new() 
	{
		super();
		laserValue = 0;
		// This timer will be responsible for stoping a game level. Reset - initialize, start - play
		level_timer = new Timer(level_time,1); 
		level_timer.addEventListener(TimerEvent.TIMER, stop);
		background = new Background(this);             // passing my reference 
		addChild(background);
		asteroid = new AsteroidContainer(this);
		addChild(asteroid);								// Adding main asteroid sprite which will contain all asteroids 
		addChild(new Spaceship());
		numButtton = new Console(); 
		//numButtton.addEventListener(TouchEvent.TOUCH_BEGIN, handleNumButton);
		numButtton.addEventListener(MouseEvent.MOUSE_DOWN, handleNumButton);
		addChild(numButtton);
	}
	
	//This function will be called every time new level or sublevel starts  
	public function initialize()
	{
		level_timer.reset();
		asteroid.setAsteroidSpeed(1);
		asteroid_timer = new Timer(6000,10);
		asteroid_timer.addEventListener(TimerEvent.TIMER,generateAsteroid);
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
	
	// Level will start when this function is called 
	public function play()
	{
		asteroid_timer.start();  										 // Starting timer for generating asteroid.
		level_timer.start();											// starting level timer
		oldtime = Lib.getTimer();                                        // Don't use in constructor else you may notice weird behaviour 	
		addEventListener(Event.ENTER_FRAME, animate);
	}
	
	// Level will stop when this function is called implicitly by timer or explicitly using function call
	public function stop (event:TimerEvent)
	{
		asteroid_timer.stop();
		level_timer.stop();
	}
	private function animate(event:Event):Void
	{
		diffTime= Lib.getTimer() - oldtime;
		oldtime += diffTime;
		background.scrollBackground();
		asteroid.handleAsteroid();
	}
	
}