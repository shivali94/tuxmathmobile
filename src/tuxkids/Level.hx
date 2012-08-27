
/*=======================================================================================================
												LICENSE 
  =======================================================================================================
  
				The contents of this file are subject to the Mozilla Public
				License Version 2.0 (the "License"); you may not use this file
				except in compliance with the License. You may obtain a copy of
				the License at http://www.mozilla.org/MPL/2.0/

				Software distributed under the License is distributed on an "AS
				IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
				implied. See the License for the specific language governing
				rights and limitations under the License.

				The Original Code is "Tuxmath"
				
				Copyright (C) 2012 by Tux4kids.  All Rights Reserved.
				Author : Deepak Aggarwal
  =======================================================================================================*/

package tuxkids;

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

/**
 * Class for storing stats about sublevel when user plays it.
 */
private class LevelStat {
	/**
	 * Total number of question answered correctly.
	 */
	public var total_question_answered:Int;		
	/**
	 * Number of wrong attempts
	 */
	public var wrong_attempts:Int;
	/**
	 * For calculating player speed its value is between 0 to total_no_question.
	 */
	public var player_speed:Float;               
	/**
	 * Constructor.
	 */
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

/**
 * This class is used to play game at particular sublevel of level.
 * Usage:
 *     First initialize() function is called in order to set Level and sublevel
 *	   Then play() function is used to play game
 *     Stop() function is used to stop the game.
 */
class Level extends Sprite
{
	private var oldtime:Int;
	/**
	 * Used for scrolling window and animating other things and it is shared with other class.
	 */
	public  var diffTime:Int ;                  
	private var background:Background;
	private var asteroid:AsteroidContainer;
	/**
	 * Used for handling number button will will also be used for updating console screen. 
	 */
	private var numButtton:Console;					
	public var laserValue:Int;
	private var asteroid_timer:Timer;
	private  var level_timer:Timer;									// Timer for automatically end level.
	private var question_instance:GenerateQuestion;
	/**
	 * Used to store result of a sublevel. 
	 */
	public var stats:LevelStat;   
	/**
	 * Spaceship Instance.
	 */
	public var spaceship:Spaceship;                                
	public function new() 
	{
		super();
		laserValue = 0;
		question_instance = new GenerateQuestion();
		// This timer will be responsible for stoping a game level. Reset - initialize, start - play.
		level_timer = new Timer(GameConstant.level_time+7000,1);               					// Adding 7 sec more  
		level_timer.addEventListener(TimerEvent.TIMER, stop);
		//Timer for generating asteroid.
		asteroid_timer = new Timer(GameConstant.level_time/GameConstant.no_of_question,GameConstant.no_of_question-1);
		asteroid_timer.addEventListener(TimerEvent.TIMER, generateAsteroid);
		background = new Background(this);             	// passing it's reference 
		addChild(background);
		asteroid = new AsteroidContainer(this);
		addChild(asteroid);								// Adding main asteroid sprite which will contain all asteroids. 
		spaceship = new Spaceship();
		addChild(spaceship);
		numButtton = new Console();                     // Contains Number Buttons and console screen. 
		//numButtton.addEventListener(TouchEvent.TOUCH_BEGIN, handleNumButton);
		numButtton.addEventListener(MouseEvent.MOUSE_DOWN, handleNumButton);
		addChild(numButtton);
		stats = new LevelStat();
	}
	
	/**
	 * This function will be called every time new level or sublevel starts.  <br>
	 * @param	level
	 * @param	sublevel
	 */
	public function initialize(level:Int , sublevel:Int)
	{
		background.initializeBackground(level,sublevel);	// Resetting Background 
		level_timer.reset();								// Resetting level timer 
		stats.reset();										// Resetting level stats 
		asteroid.stop();									// Making sure everything is clean before starting 
		asteroid.setAsteroidSpeed(1);
		asteroid_timer.reset();								// reset timer 
		question_instance.setQuestions(level, sublevel);	//Setting Level and Sublevel
	}
	
	/**
	 * This function will be responsibe for receving and handling number buttons .
	 * @param	ev
	 */
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
	
	private function generateAsteroid(ev:TimerEvent)
	{
		asteroid.addAsteroid(question_instance.newQuestion());
	}
	
	/**
	 * Level will start when this function is called.
	 */
	public function play()
	{
		// Adding first comet as soon as game starts 
		generateAsteroid(new TimerEvent(TimerEvent.TIMER));
		asteroid_timer.start();  										 // Starting timer for generating asteroid.
		level_timer.start();											// starting level timer
		oldtime = Lib.getTimer();                                        // Don't use in constructor else you may notice weird behaviour 	
		addEventListener(Event.ENTER_FRAME, animate);
	}
	
	/**
	 * For pausing game.
	 */
	public function pause()
	{
		// Stoping all timers
		level_timer.stop();
		asteroid_timer.stop();
		// Stoping animation 
		removeEventListener(Event.ENTER_FRAME, animate);
	}
	
	/**
	 * For resuming game. 
	 */
	public function resume()
	{
		oldtime = Lib.getTimer();      // Important - Updating time to new time so that we can get correct value of diffTime
		//Starting all timers 
		level_timer.start();
		asteroid_timer.start();
		//Starting animation 
		addEventListener(Event.ENTER_FRAME, animate);
	}
	
	/**
	 * Level will stop when this function is called implicitly by timer or explicitly called.
	 * @param	event
	 */
	public function stop (event:TimerEvent)
	{
		removeEventListener(Event.ENTER_FRAME, animate);
		asteroid_timer.stop();
		level_timer.stop();
		this.dispatchEvent( new Event("Game Complete"));
	}
	
	/**
	 * Called when player choose to quit game. 
	 */
	public function forceQuit()
	{
		removeEventListener(Event.ENTER_FRAME, animate);
		asteroid_timer.stop();
		level_timer.stop();
		asteroid.stop();		// Making all asteroids inactive 
	}
	
	/**
	 * Updating everything from background to asteroids using time based animation.
	 * @param	event
	 */
	private function animate(event:Event):Void
	{
		diffTime= Lib.getTimer() - oldtime;
		oldtime += diffTime;
		background.scrollBackground();
		asteroid.handleAsteroid();
	}
	
}