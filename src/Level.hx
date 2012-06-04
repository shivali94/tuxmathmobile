package ;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Level extends Sprite
{

	private var scrollBackgroundPixel:Int;  // No of pixel that will be scrolled in one step 
	private var stageWidth:Int;				// for stage width 
	private var stageHeight:Int;			// for stage height 
	private var backgroundBitmapImage:Bitmap;  // for loading background Image 
	private var scrollWindow:Rectangle;         // Clipping window for background Image 
	private var oldtime:Int ;                   // Used for time based animation
	private var deltaMovement:Float;
	private var backroundScrollSpeed:Float;     // background scrolling speed
	private var nextUpdateTime:Int ;
	private var nextUpdate:Int ;
	public function new() 
	{
		super();
		stageHeight = Lib.current.stage.stageHeight;    
		stageWidth = Lib.current.stage.stageWidth;
		scrollWindow = new Rectangle(0, 0, stageWidth, stageHeight);    // Initializing clipping window 
		loadBackground();                                              // Loading Background sprite 
		loadSpaceship();
		deltaMovement = 0.02;
		backroundScrollSpeed = 1 * deltaMovement;
		nextUpdate = 40;				 								// try to update at 25 FPS in order to lower cpu/gpu load 
	}
	
	/*===================================================================================================
	 * This function is used for loading background Image.
	====================================================================================================*/
	private function loadBackground()
	{
		backgroundBitmapImage = new Bitmap(Assets.getBitmapData("assets/background/background_space.png"));
		backgroundBitmapImage.scrollRect = scrollWindow;
		addChild(backgroundBitmapImage);
		oldtime = Lib.getTimer();                                        // Don't use in constructor else you may notice weird behaviour 
	}
	public function loadSpaceship()
	{
		var spaceship:Bitmap = new Bitmap(Assets.getBitmapData("assets/spaceship/spaceship.png"));
		spaceship.y = (Lib.current.stage.stageHeight - spaceship.height) / 2;
		addChild(spaceship);
	}
	public function scrollBackground()
	{
		var diffTime:Int = Lib.getTimer() - oldtime;
		if (nextUpdateTime > diffTime)
			return;
		scrollWindow.x = diffTime * backroundScrollSpeed;
		backgroundBitmapImage.scrollRect = scrollWindow;
		nextUpdateTime += nextUpdate;                                    // Incrementing next screen update time 
	}
}