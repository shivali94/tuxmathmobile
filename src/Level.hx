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
class LevelStat {
	public var total_question_answered:Int;
	public var wrong_attempts:Int;
	public var player_speed:Float;                //  For calculating player speed its value is between 0 to total_no_question
	public function new()
	{
		total_question_answered = 0;
		wrong_attempts = 0;
		player_speed = 0;
	}
	public function reset()
	{
		total_question_answered = 0;
		wrong_attempts = 0;
		player_speed = 0;
	}
}

class Level extends Sprite
{
	private var oldtime:Int;
	public  var diffTime:Int ;                   // Used for scrolling window and animating other things and it is shared with other class
	private var background:Background;
	private var asteroid:AsteroidContainer;
	private var numButtton:Console;					// Used for handling number button will will also be used for updating console screen 
	public var laserValue:Int;
	private var asteroid_timer:Timer;
	static  var level_time:Int=150000;						// Level time   - 2.5 minutes 
	public  var level_timer:Timer;							// Timer for automatically end level;
	private var question_instance:GenerateQuestion;
	private static var total_questions:Int = 20;			// Total number of question in subLevel;
	var stats:LevelStat;                                    // Used to store result of a sublevel 
	public function new() 
	{
		super();
		laserValue = 0;
		question_instance = new GenerateQuestion();
		// This timer will be responsible for stoping a game level. Reset - initialize, start - play
		level_timer = new Timer(level_time+5000,1);               // Adding 5 sec more  
		level_timer.addEventListener(TimerEvent.TIMER, stop);
		background = new Background(this);             // passing my reference 
		addChild(background);
		asteroid = new AsteroidContainer(this);
		addChild(asteroid);								// Adding main asteroid sprite which will contain all asteroids 
		addChild(new Spaceship());
		numButtton = new Console();                      // Contains Number Buttons and console screen 
		//numButtton.addEventListener(TouchEvent.TOUCH_BEGIN, handleNumButton);
		numButtton.addEventListener(MouseEvent.MOUSE_DOWN, handleNumButton);
		addChild(numButtton);
		stats = new LevelStat();
	}
	
	//This function will be called every time new level or sublevel starts  
	public function initialize()
	{
		level_timer.reset();								// Reseting level timer 
		stats.reset();										// Resetting level stats 
		asteroid.setAsteroidSpeed(1);
		asteroid_timer = new Timer(level_time/total_questions,total_questions-1);
		asteroid_timer.addEventListener(TimerEvent.TIMER, generateAsteroid);
		question_instance.setQuestions(1, 6);										//Setting Level and Sublevel
	}
	
	// This function will be responsibe for receving and handling number buttons 
	public function handleNumButton (ev:Event)
	{
		if (Std.is(ev.target,TextField))
			laserValue = laserValue * 10 + ev.target.parent.value;
		else
			laserValue = laserValue * 10 + ev.target.value;
		var result = asteroid.attackAsteroid();
		if (result.result == true)
			{
				stats.total_question_answered++;             // Increasing number of questions answered correctly 
				stats.player_speed += result.score;           // Adding score to overall score 
				laserValue = 0;
			}
		if (laserValue > 10)
		{
			laserValue = 0;							//Resetting Laser value
			if (result.result != true)
				stats.wrong_attempts++;				// Increasing wrong attemps when user give wrong answer 
		}
		numButtton.updateConsoleScreen("0" + laserValue);
	}
	
	public function generateAsteroid(ev:TimerEvent)
	{
		asteroid.addAsteroid(question_instance.newQuestion());
	}
	
	// Level will start when this function is called 
	public function play()
	{
		// Adding first comet as soon as game starts 
		generateAsteroid(new TimerEvent(TimerEvent.TIMER));
		asteroid_timer.start();  										 // Starting timer for generating asteroid.
		level_timer.start();											// starting level timer
		oldtime = Lib.getTimer();                                        // Don't use in constructor else you may notice weird behaviour 	
		addEventListener(Event.ENTER_FRAME, animate);
	}
	
	// Level will stop when this function is called implicitly by timer or explicitly using function call
	public function stop (event:TimerEvent)
	{
		removeEventListener(Event.ENTER_FRAME, animate);
		asteroid_timer.stop();
		level_timer.stop();
		this.dispatchEvent( new Event("Level Complete"));
	}
	private function animate(event:Event):Void
	{
		diffTime= Lib.getTimer() - oldtime;
		oldtime += diffTime;
		background.scrollBackground();
		asteroid.handleAsteroid();
	}
	
}