package ;

/**
 * ...
 * @author Deepak Aggarwal
 */
import com.eclecticdesignstudio.motion.actuators.FilterActuator;
import flash.geom.Point;
import flash.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.Shape;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Tilesheet;
import nme.Lib;
import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Rectangle;
import nme.media.SoundChannel;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import MainMenu;
/**
 * ...
 * @author Deepak Aggarwal
 */
/*===================== For showing various sublevels=============================================
 * 
 * 
 * ===============================================================================================*/

private class Constant
{
	public static var width:Int;
	public static var height:Int;
	public static var horizontal_border:Int;
	public static var vertical_border:Int;
	public static var text_format;
	static var text:TextField;
	public static var starTile:Tilesheet;    // Tile for drawing star 
	public static var empty_starTile: Tilesheet;                      // Tile for drawing empty star
	public static var scale:Float;									// Used to scale text field 
	public static function initialize()
	{
		var sprite_width = GameConstant.stageWidth * 0.8;
		var sprite_height = GameConstant.stageHeight * 0.8;
	
		// Just calculating some stuffs to display things nicely
		width = cast sprite_width * 0.8 / 5;             
		height =cast sprite_height * 0.7 / 2;
		horizontal_border = cast ((sprite_width - width * 5) / 6);
		vertical_border = cast ((sprite_height - height * 2) / 3);
		
		text = new TextField();
		text_format = new TextFormat('Arial', 127, 0xFFFFFF, true);
		text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.text = "8";
		text_format.leftMargin = 0;
		text_format.rightMargin = 0;
		var textSize:Float = height*0.8 ;                         //  Will cover 100% of button height
		// Setting size of text 
		if (text.textHeight > textSize)
			while (text.textHeight > textSize)
			{
				text_format.size-=2;
				text.setTextFormat(text_format);
				scale = 1;
			}
		else
			if(text.textHeight < textSize)
			{
				scale = textSize / text.textHeight;				
			}
		// Loading star tile	
		starTile = new Tilesheet( Assets.getBitmapData("assets/star.png"));
		starTile.addTileRect( new Rectangle(0, 0, starTile.nmeBitmap.width, starTile.nmeBitmap.height));
		//Loading empty star tile 
		empty_starTile = new Tilesheet( Assets.getBitmapData("assets/empty_star.png"));
		empty_starTile.addTileRect( new Rectangle(0, 0, empty_starTile.nmeBitmap.width, empty_starTile.nmeBitmap.height));
	}
}

/*============================================================================
 * Used for displaying sublevel menu 
 * ===========================================================================*/

class SubLevels extends Sprite
{
	public var value:Int;
	static var shape:Shape;
	var panel:Sprite;
	
	// For drawing stars that player score in a particular sublevel
	public function drawStar(number:Int)
	{
		panel.graphics.clear();
		for (x in 0...number)
		{
			Constant.starTile.drawTiles(panel.graphics,[Constant.starTile.nmeBitmap.width*x,0,0]);
		}
		for (x in number...3)
		{
			Constant.empty_starTile.drawTiles(panel.graphics,[Constant.starTile.nmeBitmap.width*x,0,0]);
		}
		panel.x = (Constant.width - panel.width) / 2;
	}
	public function new (param:Int)
	{
		super();
		value = param;
		shape = new Shape();
		panel = new Sprite();
		// Drawing main box
		shape.graphics.clear();
		shape.graphics.beginFill(0x2068C7);
		shape.alpha = 0.5;
		shape.graphics.drawRect(0, 0, Constant.width, Constant.height);
		addChild(shape);
		shape.graphics.endFill();
		// Drawing bottom strip that will contain stars 
		shape.graphics.beginFill(0x2068C7);
		shape.alpha = 0.5;
		shape.graphics.drawRect(0, Constant.height*0.8, Constant.width, Constant.height*0.2);
		addChild(shape);
		shape.graphics.endFill();
		
		// Adding text
		var text:TextField = new TextField();
		text.text = ""+value;
		text.setTextFormat(Constant.text_format);
		text.scaleX = text.scaleY = Constant.scale;
		text.height = Constant.height * 0.8;
		text.width = Constant.width;
		text.selectable = false;
		addChild(text);
		
		// adding star panel
		panel.y = Constant.height * 0.8 ;
		addChild(panel);
	}
}
   
// Sprite containing all the buttons displaying submenus
class LevelMenu extends Sprite
{
	var sublevels:Array<SubLevels>; 
	public function new ()
	{
		super();
		Constant.initialize();
		sublevels = new Array<SubLevels>();
		// Placing sublevel buttons
		for ( x in 0...10)
		{
			var temp = new SubLevels(x);
			temp.x = Constant.horizontal_border * ((x%5) + 1) + Constant.width * (x%5);
			if (x < 5)
				temp.y = Constant.vertical_border;
			else
				temp.y = Constant.vertical_border * 2 + Constant.height;
			addChild(temp);
			sublevels.push(temp);
		}
	}
	
	// Changing stars/ score based on parameters passed for particular level
	public function initializeScore(param:Array<Int>)
	{
		for (x in 0...10)
			sublevels[x].drawStar(param[x]);
	}
}
 // Main Sprite that will be responsible for displaying menu and submenus 
class MenuHandler extends Sprite
{
	public var level:Int;
	public var sublevel:Int;
	var sublevelmenu:LevelMenu;
	var main_menu_screen:MainMenu;
	public function new() 
	{
		super();
		addChild(new Bitmap(Assets.getBitmapData("assets/background/main_background.png")));
		main_menu_screen = new MainMenu();
		// Sublevel menu 
		sublevelmenu = new LevelMenu();
		sublevelmenu.x = GameConstant.stageWidth * 0.1;
		sublevelmenu.y = GameConstant.stageHeight * 0.1;
		//Back Button
		var back_button:Sprite = Button.button("BACK", 0xED1C1C, GameConstant.stageHeight/ 6);
		back_button.y = GameConstant.stageHeight - back_button.height;
		back_button.alpha = 0.7;
		// Adding stardust 
		addChild(GameConstant.star_dust);
		// Displaying Main menu 
		addChild(main_menu_screen);
		// Playing stardust
		GameConstant.star_dust.play();
		// Play sound when added to stage
		var sound_instance:SoundChannel;							// Used for stopping playing sound
		sound_instance = GameConstant.background_sound.play(0, -1);                   // Playing background sound
		
		GameConstant.star_dust.register(main_menu_screen.planets);			// Registering planet sprite so that stardust move wih respect to it
		// Displaying sublevels 
		addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
			if (!Std.is(event.target, Planet))
				return;
				level = event.target.value;
				// Initializing star score of sublevels
				sublevelmenu.initializeScore(SavedData.score[level]);
				sound_instance.stop();
				GameConstant.star_dust.stop();								// Stoping stardust for better performance 
				Transition.zoomIn([sublevelmenu, back_button], [main_menu_screen], this);			// No need to remove stardust
				function temp_function(ev:Event)
				{
					GameConstant.star_dust.play();
					Transition.dispatch.removeEventListener(Transition.TRANSITION_COMPLETE, temp_function);
				}
				Transition.dispatch.addEventListener(Transition.TRANSITION_COMPLETE, temp_function); 
				/*     To be replaced with transition statement if we don't want any transitions 
				addChild(sublevelmenu);
				addChild(back_button);
				removeChild(main_menu_screen);	
				*/
			});
			
		//sublevel handler 
		addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
			if (Std.is(event.target, SubLevels))
			{
				sublevel = event.target.value;
				trace("Level selected is:" + (level+1) + " and sublevel is: " + (sublevel+1));
				this.dispatchEvent( new Event("Start Game"));
			}
			if (Std.is(event.target.parent, SubLevels))
			{
				sublevel = event.target.parent.value;
				trace("Level selected is:" + (level+1) + " and sublevel is: " + (sublevel+1));
				this.dispatchEvent( new Event("Start Game"));
			}
		});
			
		// Back button handler 
		back_button.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
				level = -1;                     // No vaid choice has been made
				GameConstant.star_dust.stop();							// Stoping stardust for better performance
				Transition.zoomIn([main_menu_screen], [sublevelmenu, back_button], this);
				// Waiting for transition to be finished 
				function temp_function(ev:Event)
				{
					sound_instance = GameConstant.background_sound.play(0, -1);
					GameConstant.star_dust.play();										// Playing stardust again
					Transition.dispatch.removeEventListener(Transition.TRANSITION_COMPLETE, temp_function);
				}
				Transition.dispatch.addEventListener(Transition.TRANSITION_COMPLETE, temp_function); 
				/*
				removeChild(sublevelmenu);
				removeChild(back_button);
				addChild(main_menu_screen);	
				*/
			});
	}
	
	// This function is used to show updated star score when a game ends and player is redirected to sublevel menu 
	// screen again.
	public function refreshScore() {
		sublevelmenu.initializeScore(SavedData.score[level]);
	}
}