package ;
import nme.display.Sprite;
import nme.Assets ;
import nme.display.Bitmap;
import nme.display.Tilesheet;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Background extends Sprite
{
	private var stageWidth:Int;				// for stage width 
	private var stageHeight:Int;			// for stage height 
	private var deltaMovement:Float;
	private var backroundScrollSpeed:Float;     // background scrolling speed
	private var levelInstance:Level;
	private var sprite1:Sprite;
	private var sprite2:Sprite;
	private var tilesheet:Tilesheet;
	private var no_of_sheets:Int;
	private static var current_sheet:Int = 0;
	var array:Array<Float>;
	public function new(param:Level) 
	{
		super();
		stageHeight = GameConstant.stageHeight;    
		stageWidth = GameConstant.stageWidth;
		levelInstance = param;
		deltaMovement = 0.02;
		backroundScrollSpeed = 1 * deltaMovement;
		sprite1 = new Sprite();
		sprite2 = new Sprite();
		tilesheet = new Tilesheet(Assets.getBitmapData("assets/background/background_space.png"));
		no_of_sheets = Math.ceil(tilesheet.nmeBitmap.width / stageWidth);
		for (x in 0...no_of_sheets)
		{
			tilesheet.addTileRect(new Rectangle(stageWidth * x, 0, stageWidth, stageHeight));
		}
		addChild(sprite1);
		addChild(sprite2);
		initializeBackground();												// Loading Background
	}
	
	/*===================================================================================================
	 * This function is used for initializing background Image.
	====================================================================================================*/
	public  function initializeBackground()
	{
		tilesheet.drawTiles(sprite1.graphics, [0,0,0]);
		tilesheet.drawTiles(sprite2.graphics, [0,0,1]);
		sprite1.x = 0;
		sprite2.x = sprite1.x + sprite1.width;
		current_sheet = 2;
	}
	public function scrollBackground()
	{
		sprite1.x -= levelInstance.diffTime * backroundScrollSpeed;  
		sprite2.x -= levelInstance.diffTime * backroundScrollSpeed;  

		if (sprite1.x < -sprite1.width) {
			tilesheet.drawTiles(sprite1.graphics, [0,0,current_sheet]);					 // Drawing new background to sprite 
			sprite1.x = sprite2.x + sprite2.width;								// Placing sprite 
			current_sheet++;
		}else 
			if (sprite2.x < -sprite2.width) {
				tilesheet.drawTiles(sprite2.graphics,[0,0,current_sheet]);					 // Drawing new background to sprite 
				sprite2.x = sprite1.x + sprite1.width;								// Placing sprite 
				current_sheet++;
			}
	}
	
}