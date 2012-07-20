package ;

/**
 * ...
 * @author Deepak
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
	public static var text_format;
	static var text:TextField;
	public static var starTile:Tilesheet;    // Tile for drawing star 
	public static var empty_starTile: Tilesheet;                      // Tile for drawing empty star
	public static var scale:Float;									// Used to scale text field 
	public static var center:Int;
	public static var radius:Int;
	public static function initialize()
	{
		var sprite_width = GameConstant.stageWidth * 0.8;
		var sprite_height = GameConstant.stageHeight * 0.8;
	
		// Just calculating some stuffs to display things nicely
		width = cast sprite_width / 4;             
		height =cast sprite_height / 2;
		center = cast GameConstant.stageWidth * 0.4;
		center -= cast (width / 3);					// Necessary inorder to set correct center
		radius = cast sprite_width / 2;
		
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
		shape.alpha = 0.7;
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
		text.x = (Constant.width - text.width) / 2;
		text.selectable = false;
		addChild(text);
		
		// adding star panel
		panel.y = Constant.height * 0.8 ;
		addChild(panel);
	}
}
   
// Sprite containing all the buttons displaying submenus
class SubLevelMenu extends Sprite
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
			temp.y = GameConstant.stageHeight / 10;
			addChild(temp);
			sublevels.push(temp);
		}
		var angle:Float = 0;
		var temp:SubLevels;
		var effective_angle:Float;
		this.addEventListener(Event.ADDED_TO_STAGE, function(ev:Event)
		{
			this.addEventListener(Event.ENTER_FRAME, function(ev:Event)
			{
				if (angle > =360)
						angle = 0;
				for (x in 0...10)
				{
					temp = sublevels[x];
					effective_angle = Math.PI * (angle + 36 * x) / 180;
					temp.x = Constant.center - Math.cos(effective_angle) * Constant.radius;
					temp.alpha = temp.scaleX = temp.scaleY = (Math.sin(effective_angle) +2) / 3;
				}
				angle++;
				trace("altering"+angle);
			});
		});
	}
	
	// Changing stars/ score based on parameters passed for particular level
	public function initializeScore(param:Array<Int>)
	{
		for (x in 0...10)
			sublevels[x].drawStar(param[x]);
	}
}