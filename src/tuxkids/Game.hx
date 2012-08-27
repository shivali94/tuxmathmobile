
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

import haxe.Timer;
import nme.events.TimerEvent;
import nme.Lib;
import nme.events.Event;
import nme.Assets;
/**
 * ...
 * @author Deepak Aggarwal
 */
/**
 * Class which is responsible for actual handling of game like starting, pausing and stoping game.
 */
class Game 
{
	var level_instance:Level;                 	// Used for playing game.
	/**
	 * Used for displaying main menu.
	 */
	public var menu_handler:MenuHandler;			
	var game_tutorial:GameTutorial;
	public var isPlaying:Bool;					// Indicate whether player is actually playing game of not.

	/**
	 * Function for pausing game.
	 */
	public function pauseGame()
	{
		level_instance.pause();
		trace("Paused");
	}
	
	/**
	 * Function for resuming game after it has been paused.
	 */
	public function resumeGame()
	{
		level_instance.resume();
	}
	
	/**
	 * For stoping game forcefully.
	 */
	public function forceStopGame()
	{
		isPlaying = false;
		// Stoping game
		level_instance.forceQuit();
		// Removing level sprite.
		Lib.current.removeChild(level_instance);
		// Adding menu_handler sprite. 
		Lib.current.addChild(menu_handler);
	}
	
	/**
	 * Function  for calculating score.
	 */
	private function calculate_score()
	{
		// 500 for speed points 
		var speed:Int  = cast (level_instance.stats.player_speed / GameConstant.no_of_question) * 250;    
		var accuracy:Int  = cast (level_instance.stats.wrong_attempts * ( -25)) + 250;
		if (accuracy < 0)										// Score can't be negetive. 
			accuracy = 0;		
		var answered:Int = cast (level_instance.stats.total_question_answered / GameConstant.no_of_question) * 1500;
		return ({speed:speed,accuracy:accuracy,answered:answered});
	}
	
	/**
	 * It will be responsible for loading main screen which will show all levels and sublevel with their corresponding star.
	 * */
	private function mainGameScreen()
	{
		//This should be done first so that initial loading time is low.
		Lib.current.addChild(menu_handler);
		menu_handler.addEventListener("Start Game",startGame);
		level_instance.addEventListener("Game Complete",gameComplete);
	}
	
	/**
	 * For starting game. <br>
	 * @param	ev
	 */
	function startGame(ev:Event){
		// +1 because values are starting from 0.
		game_tutorial.initializeText(menu_handler.level + 1, menu_handler.sublevel + 1);
		Lib.current.removeChild(menu_handler);													// removing menu handler.
		Lib.current.addChild(game_tutorial);
		// Adding event listener for OK button.
		function call_back (ev:Event) {
			game_tutorial.removeEventListener("OK", call_back);
			Lib.current.removeChild(game_tutorial);
			level_instance.initialize(menu_handler.level + 1, menu_handler.sublevel + 1);       // Initializing Handler.
			Lib.current.addChild(level_instance);          										// Adding level sprite. 
			level_instance.play();
			isPlaying = true;
		}
		game_tutorial.addEventListener("OK",call_back);
	}
	
	/**
	 * Called after game has been completed so that we can calculate score, save it and then refresh score.  
	 * @param	ev
	 */
	function gameComplete(ev:Event) {
		var temp = calculate_score();
		var total_score = temp.accuracy + temp.answered + temp.speed;
		//Calculating stars and storing it.
		if (total_score >= GameConstant.star_3)
			SavedData.storeData(menu_handler.level, menu_handler.sublevel, 3);
			else if (total_score >= GameConstant.star_2)
				SavedData.storeData(menu_handler.level, menu_handler.sublevel, 2);
				else if (total_score >= GameConstant.star_1)
					SavedData.storeData(menu_handler.level, menu_handler.sublevel, 1);
					else
						SavedData.storeData(menu_handler.level, menu_handler.sublevel, 0);
			
		Lib.current.removeChild(level_instance);
		menu_handler.refreshScore();							// Refreshing score so that user can see updated score. 
		Lib.current.addChild(menu_handler);
		isPlaying = false;                              		// Setting isPlaying to false.
	}
	
	/**
	 * Constructor
	 */
	public function new() 
	{
		level_instance = new Level();							
		menu_handler = new MenuHandler();
		game_tutorial = new GameTutorial();
		// For retriving and storing data.
		SavedData.initialize();
		mainGameScreen();										// Star showing menu screen
		isPlaying = false;                            			// Setting isPlaying to false.
	}
}