package tuxkids;

/**
 * ...
 * @author Deepak
 */

import com.eclecticdesignstudio.motion.actuators.FilterActuator;
import nme.geom.Point;
import nme.geom.Rectangle;
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
import nme.text.Font;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.display.BitmapData;

/**
 * ...
 * @author Deepak Aggarwal
 */

 /**
  * Class for intializing constant for submenu
  */
private class Constant
{
	public static var width:Int;
	public static var height:Int;
	public static var text_format;
	public static var starTile:Tilesheet;    // Tile for drawing star 
	public static var empty_starTile: Tilesheet;                      // Tile for drawing empty star
	public static var scale:Float;									// Used to scale text field 
	public static var center:Int;
	public static var radius:Int;
	public static var angle_per_pixel:Float;						// angle moved when user swipe finger one pixel
	public static var shape:Shape;
	public static var text:TextField;
	public static var render_sprite:Sprite;							// Used for rendering options for submenulevel
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
		var temp:Font = Assets.getFont("assets/fonts/BadMofo.ttf");
		text_format = new TextFormat(temp.fontName, 127, 0xFFFFFF);
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
		
		angle_per_pixel = 0.5 * 480 / GameConstant.stageWidth;       // Taking 480 X 320 as a reference 
		
		shape = new Shape();
		// Drawing main box
		shape.graphics.clear();
		shape.graphics.beginFill(0x2068C7);
		shape.alpha = 0.3;
		shape.graphics.drawRect(0, 0, Constant.width, Constant.height);
		shape.graphics.endFill();
		// Drawing bottom strip that will contain stars 
		shape.graphics.beginFill(0x2068C7);
		shape.alpha = 0.5;
		shape.graphics.drawRect(0, Constant.height * 0.8, Constant.width, Constant.height * 0.2);
		shape.graphics.endFill();
		
		text = new TextField();
		text.text = ""+0;
		text.setTextFormat(Constant.text_format);
		text.scaleX = text.scaleY = Constant.scale;
		text.height = Constant.height * 0.8;
		text.x = (Constant.width - text.width) / 2;
		text.selectable = false;
		
		render_sprite = new Sprite();
		render_sprite.addChild(shape);
	}
}

/**
 * Class for rendering submenu
 */
class SubLevels extends Sprite
{
	/**
	 * Value of submenu
	 */
	public var value:Int;
	var panel:Sprite;
	var image:Bitmap;
	var capture_bitmap:BitmapData;
	/**
	 * For drawing stars that player score in a particular sublevel.
	 * @param	number :- No of stars to be displayed.
	 */
	public function drawStar(number:Int)
	{
		panel.graphics.clear();
		// Drawing stars
		for (x in 0...number)
		{
			Constant.starTile.drawTiles(panel.graphics,[Constant.starTile.nmeBitmap.width*x,0,0]);
		}
		for (x in number...3)
		{
			Constant.empty_starTile.drawTiles(panel.graphics,[Constant.starTile.nmeBitmap.width*x,0,0]);
		}
		panel.x = (Constant.width - panel.width) / 2;
		refresh();
	}
	/**
	 * Constructor  <br>
	 * @param	param:- value of sublevel.
	 */
	public function new (param:Int)
	{
		super();
		value = param;
		panel = new Sprite();
		capture_bitmap = new BitmapData(Constant.width, Constant.height,true,0x00000000);
		image = new Bitmap(capture_bitmap);
		addChild(image);
		refresh();
	}
	/**
	 * For refreshing and rendering sublevel
	 */
	private function refresh()
	{
		Constant.text.text = "" + value;
		Constant.text.setTextFormat(Constant.text_format);
		Constant.text.scaleX = Constant.text.scaleY = Constant.scale;
		// Adding text
		Constant.render_sprite.addChild(Constant.text);
		// adding star panel
		Constant.render_sprite.addChild(panel);
		panel.y = Constant.height * 0.8 ;
		capture_bitmap.fillRect(capture_bitmap.rect, 0x00000000);						// clearing everything
		capture_bitmap.draw(Constant.render_sprite);
		
		// Removing all display object
		Constant.render_sprite.removeChild(Constant.text);
		Constant.render_sprite.removeChild(panel);
	}
}
   
/**
 * Sprite containing all the buttons displaying submenus.
 */
class SubLevelMenu extends Sprite
{
	/**
	 * For holding sublevel
	 */
	var sublevels:Array<SubLevels>;
	/**
	 * Constructor
	 */
	public function new ()
	{
		super();
		Constant.initialize();
		sublevels = new Array<SubLevels>();
		var effective_angle:Float;
		// Necessary so that sprites can easily rotate 
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0x000000);
		shape.graphics.drawRect(0, 0, GameConstant.stageWidth, GameConstant.stageHeight);
		shape.graphics.endFill();
		shape.alpha = 0;
		addChild(shape);
		// Placing sublevel buttons
		for ( x in 0...10)
		{
			var temp = new SubLevels(x);
			temp.y = GameConstant.stageHeight / 10;
			effective_angle = Math.PI * (36 * x) / 180;
			temp.x = Constant.center - Math.cos(effective_angle) * Constant.radius;
			temp.alpha = temp.scaleX = temp.scaleY = (Math.sin(effective_angle) +2) / 3;
			addChild(temp);
			sublevels.push(temp);
		}
		
		var angle:Float = 0;
		var temp:SubLevels;
		var old_x:Int;
		this.addEventListener(MouseEvent.MOUSE_DOWN, function(param:MouseEvent) {
			old_x = param.target.mouseX;
		});
		this.addEventListener(MouseEvent.MOUSE_MOVE, function(param:MouseEvent) {
			angle += (param.target.mouseX - old_x) * Constant.angle_per_pixel;
			old_x = param.target.mouseX;
			if (angle > =360 || angle <= -360)
				angle = 0;
				for (x in 0...10)
				{
					temp = sublevels[x];
					effective_angle = Math.PI * (angle + 36 * x) / 180;
					temp.x = Constant.center - Math.cos(effective_angle) * Constant.radius;
					temp.alpha = temp.scaleX = temp.scaleY = (Math.sin(effective_angle) +2) / 3;
				}
		});
	}
	
	/**
	 * Changing stars/score based on parameters passed for particular level.
	 * @param	param :- Scores to be initialized.
	 */
	public function initializeScore(param:Array<Int>)
	{
		for (x in 0...10)
			sublevels[x].drawStar(param[x]);
	}
}