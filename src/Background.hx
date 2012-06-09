package ;
import nme.display.Sprite;
import nme.Assets ;
import nme.display.Bitmap;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Background extends Sprite
{
	private var backgroundBitmapImage:Bitmap;  // for loading background Image 
	private var scrollWindow:Rectangle;         // Clipping window for background Image 
	private var stageWidth:Int;				// for stage width 
	private var stageHeight:Int;			// for stage height 
	private var deltaMovement:Float;
	private var backroundScrollSpeed:Float;     // background scrolling speed
	private var levelInstance:Level;
	public function new(param:Level) 
	{
		super();
		stageHeight = Lib.current.stage.stageHeight;    
		stageWidth = Lib.current.stage.stageWidth;
		levelInstance = param;
		scrollWindow = new Rectangle(0, 0, stageWidth, stageHeight);    // Initializing clipping window 
		deltaMovement = 0.02;
		backroundScrollSpeed = 1 * deltaMovement;
		loadBackground();												// Loading Background 
	}
	
	/*===================================================================================================
	 * This function is used for loading background Image.
	====================================================================================================*/
	private function loadBackground()
	{
		backgroundBitmapImage = new Bitmap(Assets.getBitmapData("assets/background/background_space.png"));
		backgroundBitmapImage.scrollRect = scrollWindow;
		addChild(backgroundBitmapImage);
	}
	public function scrollBackground()
	{
		scrollWindow.x +=levelInstance.diffTime * backroundScrollSpeed;
		backgroundBitmapImage.scrollRect = scrollWindow;
	}
	
}