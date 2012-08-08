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
	var nebula1:Bitmap;
	var nebula2:Bitmap;
	var star_cloud1:Bitmap;
	var star_cloud2:Bitmap;
	private var deltaMovement:Float;
	private var backroundScrollSpeed:Float;     // background scrolling speed
	private var levelInstance:Level;
	private var limitx:Float;
	public function new(param:Level) 
	{
		super();
		nebula1 = new Bitmap();
		nebula2 = new Bitmap();
		addChild(nebula1);
		addChild(nebula2);
		star_cloud1 = new Bitmap(Assets.getBitmapData("assets/background/cloud3.png"));
		star_cloud2 = new Bitmap();
		star_cloud2.bitmapData = star_cloud1.bitmapData;
		addChild( new Bitmap(Assets.getBitmapData("assets/background/star.png")));
		addChild(star_cloud1);
		addChild(star_cloud2);
		//star_cloud1.alpha = star_cloud2.alpha = 0.8;
		levelInstance = param;
		deltaMovement = 0.02;
		backroundScrollSpeed = 1 * deltaMovement;
		star_cloud2.x = star_cloud1.width + star_cloud1.x;
	}
	
	/*===================================================================================================
	 * This function is used for initializing background Image.
	====================================================================================================*/
	public  function initializeBackground(level:Int , sublevel:Int)
	{
		nebula1.bitmapData = Assets.getBitmapData("assets/background/nebula and fractals/galaxy_sprite_"+level+".png");
		nebula1.x = Lib.current.stage.stageWidth * (0.15 + 0.25 * Math.random());
		nebula1.y = Lib.current.stage.stageHeight * 0.1 * Math.random();
		nebula2.bitmapData = Assets.getBitmapData("assets/background/nebula and fractals/galaxy_sprite_"+(level+1)+".png");
		nebula2.x = Lib.current.stage.stageWidth * (0.65 + (Math.random() / 5));
		nebula2.y = Lib.current.stage.stageHeight * (0.6 + (0.15 * Math.random()));
		limitx = -star_cloud1.width;
		if(level <= 2){
			star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud1.png");
			star_cloud2.bitmapData = star_cloud1.bitmapData;
		}	
		else
			if(level <= 4){
				star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud2.png");
				star_cloud2.bitmapData = star_cloud1.bitmapData;
			}	
			else
				if(level <= 6){
					star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud3.png");
					star_cloud2.bitmapData = star_cloud1.bitmapData;
				}	
				else{
					star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud4.png");
					star_cloud2.bitmapData = star_cloud1.bitmapData;
				}	
	}
	public function scrollBackground()
	{
		star_cloud1.x -= levelInstance.diffTime * backroundScrollSpeed;  
		star_cloud2.x -= levelInstance.diffTime * backroundScrollSpeed;  

		if (star_cloud1.x <= limitx) 
			star_cloud1.x = star_cloud2.x + star_cloud2.width;								// Placing sprite 
		else 
			if (star_cloud2.x <= limitx) 			
				star_cloud2.x = star_cloud1.x + star_cloud1.width;								// Placing sprite 
	}
	
}