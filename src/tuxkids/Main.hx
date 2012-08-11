package tuxkids;

import nme.geom.Point;
import nme.display.Bitmap;
import nme.display.Shape;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.events.MouseEvent;
import nme.display.FPS;
import nme.Assets;
import com.eclecticdesignstudio.motion.Actuate;
/**
 * ...
 * @author Deepak Aggarwal
 */

/**
 * Main class 
 * <br>
 * It's main function is to handle back button.
 */
class Main 
{
	static var game:Game;
	static var inMenu:Bool = false ;    //Whether in "In Game" menu (Pause) or "In Menu" menu (exit)
	static var inGameSprite:Sprite;		//Pause menu to be displayed when player is playing game.
	static var inMenuSprite:Sprite;		//Pause menu displayed when player is choosing level or sublevel.
	static var center:Point;			// Used to store center of stage for animation 
	static	var resume:Sprite;			// Resume button
	static	var main_menu:Sprite;		// Main menu button
	static	var play:Sprite;			// Play button 
	static	var quit:Sprite;			// Quit button
	static	var credits:Sprite;			// Credits button 
	/**
	 * Function for handling back button.
	 * @param	event
	 */
	static function keyHandler(event:KeyboardEvent)
	{
		if (event.keyCode == 27)
		{
			event.stopImmediatePropagation();                   // Game doesn't ends up
			if (inMenu == true)
				return;
			if (game.isPlaying == true)                        // Display Pause menu 
			{
				game.pauseGame();
				showGameSprite();
				inMenu = true;
			}
			else                                                // Display exit menu 
			{
				showMainMenu();
				inMenu = true;
			}
		}
	}
	
	/**
	 * For showing pause menu when user isn't playing the game.
	 */
	static function showMainMenu()
	{
		// Animating overlay for displaying menu
		inMenuSprite.scaleX = inMenuSprite.scaleY = 0.01;
		play.rotation = credits.rotation = quit.rotation = 45;
		play.alpha = credits.alpha = quit.alpha = 0;
		inMenuSprite.alpha = 0.1;
		// Adding it to stage
		Lib.current.addChild(inMenuSprite);
		// Zoom in effect
		Actuate.tween(inMenuSprite, 0.2, { scaleX:1, scaleY:1,alpha:1 } ).onUpdate(function() {
			inMenuSprite.x = (1 - inMenuSprite.scaleX) * center.x;
			inMenuSprite.y = (1 - inMenuSprite.scaleY) * center.y;
		}).onComplete(function() {
			// Animating buttons.
			inMenuSprite.addChild(play);
			Actuate.tween(play, 0.2, { rotation:0, alpha:1 } ).onComplete(function() {
				inMenuSprite.addChild(credits);
				Actuate.tween(credits, 0.2, { rotation:0, alpha:1 } ).onComplete(function() {
					inMenuSprite.addChild(quit);
					Actuate.tween(quit, 0.2, { rotation:0, alpha:1 } );
				});
			});
		});
	}
	
	/**
	 * Shows pause menu when user is playing game.
	 */
	static function showGameSprite()
	{
		inGameSprite.scaleX = inGameSprite.scaleY = 0.01;
		main_menu.rotation = resume.rotation = 45;
		main_menu.alpha = resume.alpha = 0;
		inGameSprite.alpha = 0.1;
		Lib.current.addChild(inGameSprite);
		//Animating overlay
		Actuate.tween(inGameSprite, 0.2, { scaleX:1, scaleY:1,alpha:1 } ).onUpdate(function() {
			inGameSprite.x = (1 - inGameSprite.scaleX) * center.x;
			inGameSprite.y = (1 - inGameSprite.scaleY) * center.y;
		}).onComplete(function() {
			// Animating buttons
			inGameSprite.addChild(resume);
			Actuate.tween(resume, 0.2, { rotation:0, alpha:1 } ).onComplete(function() {
				inGameSprite.addChild(main_menu);
				Actuate.tween(main_menu, 0.2, { rotation:0, alpha:1 } );
			});
		});
	}
	
	/**
	 * Function for hiding pause screen. (User isn't playing game)
	 */
	static function hideMainMenu()
	{
		inMenuSprite.scaleX = inMenuSprite.scaleY = 1;
		play.rotation = credits.rotation = quit.rotation = 0;
		Actuate.tween(play, 0.2, { rotation:-20, alpha:0 } ).onComplete(function() {
			inMenuSprite.removeChild(play);
			Actuate.tween(credits, 0.2, { rotation:-20, alpha:0 } ).onComplete(function() {
				inMenuSprite.removeChild(credits);
				Actuate.tween(quit, 0.2, { rotation:-20, alpha:0 } ).onComplete(function(){
					inMenuSprite.removeChild(quit);
					Actuate.tween(inMenuSprite, 0.2, { scaleX:0.01, scaleY:0.01 ,alpha:0.1} ).onUpdate(function() {
						inMenuSprite.x = (1 - inMenuSprite.scaleX) * center.x;
						inMenuSprite.y = (1 - inMenuSprite.scaleY) * center.y;
					}).onComplete(function() { Lib.current.removeChild(inMenuSprite); } );
				});
			});
		});
	}
	
	/**
	 * Function for pause menu. (User is playing game)
	 */
	static function hideGameSprite()
	{
		inGameSprite.scaleX = inGameSprite.scaleY = 1;
		main_menu.rotation = resume.rotation = 0;
		main_menu.alpha = resume.alpha = 1;
		Actuate.tween(resume, 0.2, { rotation:-20, alpha:0 } ).onComplete(function() {
			inGameSprite.removeChild(resume);
			Actuate.tween(main_menu, 0.2, { rotation:-20, alpha:0 } ).onComplete(function() {
				inGameSprite.removeChild(main_menu);
				Actuate.tween(inGameSprite, 0.2, { scaleX:0.01, scaleY:0.01 ,alpha:0.1} ).onUpdate(function() {
					inGameSprite.x = (1 - inGameSprite.scaleX) * center.x;
					inGameSprite.y = (1 - inGameSprite.scaleY) * center.y;
				}).onComplete(function() { Lib.current.removeChild(inGameSprite); } );
			});
		});
	}
	
	/**
	 * Function for initializing pause menu sprites.
	 */
	static function renderSprite()
	{
		inGameSprite = new Sprite();
		inMenuSprite = new Sprite();
		// Initializing inGame and inMenu Sprites
		var shape:Shape = new Shape();
		shape.graphics.clear();
		shape.graphics.beginFill(0x000000);
		shape.alpha = 0.75;
		shape.graphics.drawRect(0, 0, GameConstant.stageWidth, GameConstant.stageHeight);
		shape.graphics.endFill();
		var shape1:Shape = new Shape();
		shape1.graphics.clear();
		shape1.graphics.beginFill(0x000000);
		shape1.alpha = 0.75;
		shape1.graphics.drawRect(0, 0, GameConstant.stageWidth, GameConstant.stageHeight);
		shape1.graphics.endFill();
		
		// Adding background overlay (opaque)
		inGameSprite.addChild(shape);
		inMenuSprite.addChild(shape1);
		
		//Initialzing Buttons 
		resume = Button.button("RESUME", 0x14B321, GameConstant.stageHeight / 6);
		main_menu = Button.button("MAIN MENU", 0xFC4949, GameConstant.stageHeight / 6);
		play = Button.button("PLAY", 0x14B321, GameConstant.stageHeight / 6);
		quit = Button.button("QUIT", 0xDD0000, GameConstant.stageHeight / 6);
		credits = Button.button("CREDITS", 0xf8964f, GameConstant.stageHeight / 6);
		
		//Adding event listener to them
		resume.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			hideGameSprite();
			game.resumeGame();									// Resuming game
			inMenu = false;										// Not in menu
			game.isPlaying = true;								// Game is started again
		});
		main_menu.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			hideGameSprite();
			game.forceStopGame();
			inMenu = false;   
		});
		
		play.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			hideMainMenu();
			inMenu = false;
		});
		quit.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			inMenu = false;
			#if(!flash)
				Lib.exit();
			#end 
		});
		// Adding and removing credit sprite 
		credits.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			var credit:Sprite = new Sprite();
			var credit_image:Bitmap = new Bitmap(Assets.getBitmapData("assets/credits/credits.png"));    //Loading images
			credit.addChild(credit_image);
			credit.addEventListener(MouseEvent.CLICK, function(ev:Event) {
				Lib.current.removeChild(credit);
			});
			inMenu = true;                                                        						 // We are in menu
			Lib.current.addChild(credit);
		});
		
		//Adding Buttons to their corresponding sprites
		//In Game pause sprite
		main_menu.x = (inGameSprite.width-main_menu.width)/2;
		main_menu.y = inGameSprite.height/2  + inGameSprite.height/8;
		resume.x = (inGameSprite.width-resume.width)/2;
		resume.y = inGameSprite.height/2  - inGameSprite.height/8;
		//In Menu pause sprite
		quit.x = (inMenuSprite.width-quit.width)/2;
		quit.y = inMenuSprite.height/2 + inMenuSprite.height/4;
		play.x = (inMenuSprite.width - play.width)/2;
		play.y = inMenuSprite.height/2 - inMenuSprite.height/4;
		credits.x = (inMenuSprite.width - credits.width)/2;            // In the middle
		credits.y = inMenuSprite.height/2;
	}
	
	/**
	 * Main function
	 */
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		GameConstant.initialize();
		Transition.intialize();
		var rectangle:Shape = new Shape(); // initializing variable named rectangles
		// Initializing game variable.
		game = new Game();
		// Code for displaying FPS on android screen
		rectangle.graphics.beginFill(0xFFFFFF); // choosing colour for the fill, here it is red
		rectangle.graphics.drawRect(100,0, 80,40); // (x spacing, y spacing, width, height)
		rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
		Lib.current.addChild(rectangle); // adds the rectangle to the stage
		var tempfps = new FPS();
		tempfps.x = 100;
		tempfps.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			Lib.current.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false,0, 27));
		});
		Lib.current.addChild(tempfps);
		Lib.current.addEventListener(Event.ADDED, function(ev:Event) {
			Lib.current.addChild(rectangle);
			Lib.current.addChild(tempfps);
		});
		// Getting center co-ordnates of stage
		center = new Point(GameConstant.stageWidth / 2, GameConstant.stageHeight / 2);
		//First rendering sprites
		renderSprite();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
	}
}