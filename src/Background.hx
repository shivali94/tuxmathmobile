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
	private var bitmap1:Bitmap;
	private var bitmap2:Bitmap;
	private static var current_sheet:Int = 0;
	var array:Array<Float>;
	public function new(param:Level) 
	{
		super();
		stageHeight = GameConstant.stageHeight;    
		stageWidth = GameConstant.stageWidth;
		// Initializing bitmaps
		bitmap1 = new Bitmap();
		bitmap2 = new Bitmap();
		levelInstance = param;
		deltaMovement = 0.02;
		backroundScrollSpeed = 1 * deltaMovement;
		// Initializing sprites
		sprite1 = new Sprite();
		sprite2 = new Sprite();
		// Adding bitmap to sprites
		sprite1.addChild(bitmap1);
		sprite2.addChild(bitmap2);
		addChild(sprite1);
		addChild(sprite2);
		initializeBackground();												// Loading Background
	}
	
	/*===================================================================================================
	 * This function is used for initializing background Image.
	====================================================================================================*/
	public  function initializeBackground()
	{
		bitmap1.bitmapData = Assets.getBitmapData("assets/background/background_space0.png");
		bitmap2.bitmapData = Assets.getBitmapData("assets/background/background_space1.png");
		sprite1.x = 0;
		sprite2.x = sprite1.x + sprite1.width;
		current_sheet = 2;
	}
	public function scrollBackground()
	{
		sprite1.x -= levelInstance.diffTime * backroundScrollSpeed;  
		sprite2.x -= levelInstance.diffTime * backroundScrollSpeed;  

		if (sprite1.x < -sprite1.width) {
			bitmap1.bitmapData = Assets.getBitmapData("assets/background/background_space" + current_sheet + ".png");
			sprite1.x = sprite2.x + sprite2.width;								// Placing sprite 
			current_sheet++;
		}else 
			if (sprite2.x < -sprite2.width) {
				bitmap2.bitmapData = Assets.getBitmapData("assets/background/background_space" + current_sheet + ".png");					 // Drawing new background to sprite 
				sprite2.x = sprite1.x + sprite1.width;								// Placing sprite 
				current_sheet++;
			}
	}
	
}