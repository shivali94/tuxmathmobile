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
			}
			else                                                // Display exit menu 
			{
				
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
		shape.graphics.beginFill(0xFFFFFF);
		shape.alpha = 0.4;
		shape.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		
		// Adding background overlay (opaque)
		inGameSprite.addChild(shape);
		inMenuSprite.addChild(shape);
		
		//Initialzing Buttons 
		var resume:Sprite = Button.button("RESUME", 0x14B321, Lib.current.stage.width / 6);
		var quit:Sprite = Button.button("QUIT", 0xFC4949, Lib.current.stage.width / 6);
		var no:Sprite = Button.button("NO", 0x14B321, Lib.current.stage.width / 6);
		var yes:Sprite = Button.button("YES", 0xFC4949, Lib.current.stage.width / 6);
		//Adding event listener to them
		resume.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			Lib.current.removeChild(inGameSprite);
			game.resumeGame();
			inMenu = false;
		});
		quit.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			game.stopGame();
			inMenu = false;
		});
		no.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			Lib.current.removeChild(inMenuSprite);
			inMenu = false;
		});
		yes.addEventListener(MouseEvent.CLICK, function(ev:Event) {
			inMenu = false;
			//Lib.exit();
		});
		
	}
	
	static public function main() 
	{
		
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		var rectangle:Shape = new Shape(); // initializing the variable named rectangles
		game = new Game();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		
		// Code for displaying FPS on android screen
		rectangle.graphics.beginFill(0xFFFFFF); // choosing the colour for the fill, here it is red
		rectangle.graphics.drawRect(100,0, 80,40); // (x spacing, y spacing, width, height)
		rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
		Lib.current.addChild(rectangle); // adds the rectangle to the stage
		var tempfps = new FPS();
		tempfps.x = 100;
		Lib.current.addChild(tempfps);	
	}
}