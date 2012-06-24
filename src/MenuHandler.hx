package ;

/**
 * ...
 * @author Deepak Aggarwal
 */
import flash.geom.Point;
import flash.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.Shape;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Rectangle;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
/**
 * ...
 * @author Deepak Aggarwal
 */

class Planet extends Sprite {
	public var value:Int;
	var image:Bitmap;
	public function new (val:Int)
	{
		super();
		// Adding planets 
		addChild(new Bitmap(Assets.getBitmapData("assets/planet/planet" + val + ".png")));  
		value = val;
	}
}
class Planets extends Sprite 
{
	public var x_scale:Int;
	public function new ()
	{
		super();
		// Distance between two adjacent planets  
		var distance:Int = cast Lib.current.stage.stageWidth / 4;
		x_scale = 0;                               // For keeping tab on x dimension of sprite 
		for (x in 0...6)
		{
			x_scale += distance;
			var temp = new Planet(x);
			temp.x = x_scale;
			temp.y = (Lib.current.stage.stageHeight - temp.height) / 2;     // Puting it in middle
			x_scale += cast temp.width;
			addChild(temp);
 		}
	}
}
class MainMenuScreen extends Sprite
{
	public function new()
	{
		super();
		var planets = new Planets();
		// Scrolling rectangles
		var bounds:Rectangle = new Rectangle( -planets.x_scale + Lib.current.stage.stageWidth, 0, planets.x_scale-Lib.current.stage.stageWidth, 0);
		// Necessary so that sprite could be dragged easily 
		addChild(new Bitmap(Assets.getBitmapData("assets/background/main_background.png")));
		
		  // For sprite scrolling 
		addEventListener(MouseEvent.MOUSE_DOWN, function(ev:MouseEvent) {
			planets.startDrag(false, bounds);
		});
		addEventListener(MouseEvent.MOUSE_UP, function(ev:MouseEvent) {
			planets.stopDrag();
		}); 
		addEventListener(MouseEvent.MOUSE_OUT, function(ev:MouseEvent) {
			planets.stopDrag();
		});
		addChild(planets);
	}
}

/*===================== For showing various sublevels=============================================
 * 
 * 
 * =============================================================================================*/

private class Constant
{
	public static var width:Int;
	public static var height:Int;
	public static var horizontal_border:Int;
	public static var vertical_border:Int;
	public static var text_format;
	static var text:TextField;
	public static function initialize()
	{
		var sprite_width = Lib.current.stage.stageWidth * 0.8;
		var sprite_height = Lib.current.stage.stageHeight * 0.8;
	
		// Just calculating some stuffs to display things nicely
		width = cast sprite_width * 0.8 / 5;             
		height =cast sprite_height * 0.7 / 2;
		horizontal_border = cast ((sprite_width - width * 5) / 6);
		vertical_border = cast ((sprite_height - height * 2) / 3);
		
		text = new TextField();
		text_format = new TextFormat('Arial', 30, 0xFFFFFF, true);
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
				text_format.size--;
				text.setTextFormat(text_format);
			}
		else
			while (text.textHeight < textSize)
			{
				text_format.size++;
				text.setTextFormat(text_format); 
			}
	}
	
	// Used for creating button eg BACK button
	static public function button(content:String,color:Int,width:Float)
	{
		var text = new TextField();
		var text_format = new TextFormat('Arial', 30, 0xFFFFFF, true);
		text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		text.text = content;
		text_format.leftMargin = 0;
		text_format.rightMargin = 0;
		// Setting size of text 
		if (text.textWidth > width)
			while (text.textWidth > width)
			{
				text_format.size--;
				text.setTextFormat(text_format);
			}
		else
			while (text.textWidth < width)
			{
				text_format.size++;
				text.setTextFormat(text_format); 
			}
		text.height = text.textHeight;
		text.width = width;
		var shape:Shape = new Shape();
		var sprite:Sprite = new Sprite();
		shape.graphics.clear();
		shape.graphics.beginFill(color);
		shape.graphics.drawRect(0, 0, text.textWidth, text.textHeight);
		sprite.addChild(shape);
		shape.graphics.endFill();
		// Adding text
		sprite.addChild(text);
		return sprite;
	}
}

/*============================================================================
 * Used for displaying sublevel menu 
 * ===========================================================================*/

class SubLevels extends Sprite
{
	public var value:Int;
	static var shape:Shape;
	public var star:TextField;
	public static var text_format:TextFormat;
	
	// For drawing stars that player score in a particular sublevel
	function drawStar()
	{
		text_format = new TextFormat('Arial', 30, 0xFFE957, true);
		text_format.align = TextFormatAlign.CENTER;
		star.defaultTextFormat = text_format;
		star.selectable = false;
		star.text = "★★☆";
		text_format.leftMargin = 0;
		text_format.rightMargin = 0;
		var height = Constant.height * 0.2;
		// Setting size of text 
		if (star.textHeight > height)
			while (star.textHeight > height)
			{
				text_format.size--;
				star.setTextFormat(text_format);
			}
		else
			while (star.textHeight < height)
			{
				text_format.size++;
				star.setTextFormat(text_format); 
			}
		star.height = height;
		star.width = Constant.width;
	}
	public function new (param:Int)
	{
		super();
		value = param;
		shape = new Shape();
		star = new TextField();
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
		
		// Adding stars 
		var text:TextField = new TextField();
		text.text = ""+value;
		text.setTextFormat(Constant.text_format);
		text.height = Constant.height * 0.8;
		text.width = Constant.width;
		text.selectable = false;
		addChild(text);
		drawStar();
		star.y = Constant.height * 0.8;
		addChild(star);
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
		{
			sublevels[x].star.text = "";
			for (y in 0...param[x])
				sublevels[x].star.text += "★";
			for (y in param[x]...3)
				sublevels[x].star.text += "☆";
			sublevels[x].star.setTextFormat(SubLevels.text_format);
		}
	}
}
 // Main Sprite that will be responsible for displaying menu and submenus 
class MenuHandler extends Sprite
{
	public var level:Int;
	public var sublevel:Int;
	public function new() 
	{
		super();
		addChild(new Bitmap(Assets.getBitmapData("assets/background/main_background.png")));
		var main_menu_screen = new MainMenuScreen();
		// Sublevel menu 
		var sublevelmenu = new LevelMenu();
		sublevelmenu.x = Lib.current.stage.stageWidth * 0.1;
		sublevelmenu.y = Lib.current.stage.stageHeight * 0.1;
		//Back Button
		var back_button:Sprite = Constant.button("BACK", 0xED1C1C, Lib.current.stage.stageWidth / 5);
		back_button.y = Lib.current.stage.stageHeight - back_button.height;
		back_button.alpha = 0.7;
		// Displaying Main menu 
		addChild(main_menu_screen);
		addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
			if (!Std.is(event.target, Planet))
				return;
				level = event.target.value;
				addChild(sublevelmenu);
				addChild(back_button);
				removeChild(main_menu_screen);	
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
				removeChild(sublevelmenu);
				removeChild(back_button);
				addChild(main_menu_screen);	
			});
	}
	
}