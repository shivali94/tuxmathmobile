package ;

import nme.display.Shape;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.events.MouseEvent;
import nme.display.FPS;
/**
 * ...
 * @author Deepak Aggarwal
 */

class Main 
{
	static var game:Game;
	static var inMenu:Bool = false ;    //Whether in "In Game" menu (Pause) or "In Menu" menu (exit)
	static var inGameSprite:Sprite;
	static var inMenuSprite:Sprite;
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
				Lib.current.addChild(inGameSprite);
			}
			else                                                // Display exit menu 
			{
				Lib.current.addChild(inMenuSprite);
			}
		}
	}
	
	static function renderSprite()
	{
		inGameSprite = new Sprite();
		inMenuSprite = new Sprite();
		// Initializing inGame and inMenu Sprites
		var shape:Shape = new Shape();
		shape.graphics.clear();
		shape.graphics.beginFill(0x000000);
		shape.alpha = 0.75;
		shape.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		shape.graphics.endFill();
		var shape1:Shape = new Shape();
		shape1.graphics.clear();
		shape1.graphics.beginFill(0x000000);
		shape1.alpha = 0.75;
		shape1.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		shape1.graphics.endFill();
		
		// Adding background overlay (opaque)
		inGameSprite.addChild(shape);
		inMenuSprite.addChild(shape1);
		
		//Initialzing Buttons 
		var resume:Sprite = Button.button("RESUME", 0x14B321, Lib.current.stage.stageHeight / 6);
		var main_menu:Sprite = Button.button("MAIN MENU", 0xFC4949, Lib.current.stage.stageHeight / 6);
		var play:Sprite = Button.button("PLAY", 0x14B321, Lib.current.stage.stageHeight / 6);
		var quit:Sprite = Button.button("QUIT", 0xFC4949, Lib.current.stage.stageHeight / 6);
		
		//Adding event listener to them
		resume.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			Lib.current.removeChild(inGameSprite);
			game.resumeGame();									// Resuming game
			inMenu = false;										// Not in menu
			game.isPlaying = true;								// Game is started again
		});
		main_menu.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			game.forceStopGame();
			inMenu = false;   
		});
		play.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			Lib.current.removeChild(inMenuSprite);
			inMenu = false;
		});
		quit.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			inMenu = false;
			Lib.exit();
		});
		
		//Adding Buttons to their corresponding sprites
		//In Game
		main_menu.x = (inGameSprite.width-main_menu.width)/2;
		main_menu.y = inGameSprite.height/2  + inGameSprite.height/8;
		inGameSprite.addChild(main_menu);
		resume.x = (inGameSprite.width-resume.width)/2;
		resume.y = inGameSprite.height/2  - inGameSprite.height/8;
		inGameSprite.addChild(resume);
		//In Menu
		quit.x = (inMenuSprite.width-quit.width)/2;
		quit.y = inMenuSprite.height/2 + inMenuSprite.height/8;
		inMenuSprite.addChild(quit);
		play.x = (inMenuSprite.width - play.width)/2;
		play.y = inMenuSprite.height/2 - inMenuSprite.height/8;
		inMenuSprite.addChild(play);
		
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		var rectangle:Shape = new Shape(); // initializing the variable named rectangles
		game = new Game();
		// Code for displaying FPS on android screen
		rectangle.graphics.beginFill(0xFFFFFF); // choosing the colour for the fill, here it is red
		rectangle.graphics.drawRect(100,0, 80,40); // (x spacing, y spacing, width, height)
		rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
		Lib.current.addChild(rectangle); // adds the rectangle to the stage
		var tempfps = new FPS();
		tempfps.x = 100;
		Lib.current.addChild(tempfps);	
		//First rendering sprites
		renderSprite();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		 
	}
}