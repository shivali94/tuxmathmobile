package ;

/**
 * ...
 * @author Deepak
 */

import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.display.Shape;
import nme.geom.Rectangle;
import nme.Lib;
import nme.events.Event;
import nme.ui.Acceleration;
import nme.ui.Accelerometer;
import nme.geom.Point;
private class Dust 
{
	public var x:Float;
	public var y:Float;
	public function new ()
	{}
}

class StarDust extends Sprite
{
	private var starsArray:Array<Dust>;
	private var drawList:Array<Float>;
	private var starArrayLength:Int;
	private var containerX:Int;
	private var containerY:Int;
	private var containerWidth:Int;
	private var containerHeight:Int;
	private var dustTile:Tilesheet;
	private var update_vector:Point;
	private var register_sprite:Dynamic;					// Used for stardust movement effect with respect to a sprite
	private var register_sprite_old_x:Float;
	private var parallax_factor:Float;						// Used for parallax effect
	public function createStarDust()
	{
		var tempStar;		
		for (x in 0...starArrayLength)
		{
			tempStar = new Dust();
			tempStar.x = (Math.random() * containerWidth ) + containerX;
			tempStar.y = (Math.random() * containerHeight ) + containerY;
			starsArray.push(tempStar);
		}
		update_vector = new Point();
		update_vector.x = 0.4;          //x = 0.2 * cos(0)^2
		update_vector.y = 0;			 //y = 0.2 * sin(0)^2

	}
	public function new ()
	{
		super();
		starsArray = new Array<Dust>();
		drawList = new Array<Float>();
		starArrayLength = cast GameConstant.stageWidth * 1.2;
		parallax_factor = 1 - 1 / (GameConstant.stageWidth * 0.5);
		containerX = 0;
		containerY = 0;
		containerWidth = GameConstant.stageWidth;
		containerHeight = GameConstant.stageHeight;
		
		var shape = new Sprite();
		shape.graphics.clear();
		shape.graphics.beginFill(0xD6C35E);
		var radius:Float = 0.02810 * GameConstant.stageHeight / 15;
		// Atleast we should see something
		if (radius < 0.5)
			radius = 0.5;
		shape.graphics.drawCircle(0, 0,radius );
		shape.graphics.endFill();
		// Creating dust
		createStarDust();
		// Getting bitmap data
		var dust_bitmapdata:BitmapData = new BitmapData(cast shape.width, cast shape.height,true,0xFFD6C35E);
		dust_bitmapdata.draw(shape);
		//Initializing starTile
		dustTile = new Tilesheet(dust_bitmapdata);
		dustTile.addTileRect(new Rectangle(0, 0, shape.width, shape.height));
		dustTile.drawTiles(graphics, [100, 200, 0]);
		addEventListener(Event.REMOVED_FROM_STAGE, function(ev:Event)				// This is nessecary as we want to pause it when it's not visible
		{
			stop();
		});
		addEventListener(Event.ADDED_TO_STAGE, function(ev:Event)					// Play as soon as it is added to the stage 
		{
			play();
		});
	}
	public function play()
	{
		if(!hasEventListener(Event.ENTER_FRAME))				// In order to avois mutiple addition of events
		addEventListener(Event.ENTER_FRAME, updateDust);
	}
	public function stop()
	{
		if(hasEventListener(Event.ENTER_FRAME))				// Remove if only is added in order to avoid errors
		removeEventListener(Event.ENTER_FRAME, updateDust);
	}
	
	// Function used to register sprite so that star dust scroll or move with it 
	public function register(param:Dynamic)
	{
		register_sprite = param;
		register_sprite_old_x = param.x;
	}
	public function unregister()
	{
		register_sprite = null;
	}
	var index:Int;
	var tempStar:Dust;
	var delta:Float;
	#if !flash
		var temp:Acceleration;
	#end
	private function updateDust(ev:Event)
	{
		graphics.clear();
		#if !flash
			temp = Accelerometer.get();
			if (temp.x < -0)									// Rotate only when mobile is tilted 
			{
				// r(cosx^2 + sinx^2) = r ,    angle = temp.y * 100 *1.2
				update_vector.y = 0.6 * Math.sin(temp.y * Math.PI / 1.8);     
				//update_vector.x = 0.2 * Math.cos(temp.y * Math.PI/1.8);
			}
		#end
		
		if (register_sprite != null)								// If a sprite is registered 
		{
			delta = register_sprite.x - register_sprite_old_x;
			register_sprite_old_x += delta;							//Updating old x value. 
		}
		else
			delta = 0;
		delta = update_vector.x + delta;      // Adding costant update x to delta 
		for(i in 0...starArrayLength)
		{
			index = i * 3;
			tempStar = starsArray[i];
			delta *= parallax_factor;                                          // Used for producing parallax effect
			drawList[index] = tempStar.x += delta;         
			drawList[index + 1] = tempStar.y += update_vector.y;
			//Star boundres
			//check X boudries
			if (tempStar.x >= containerWidth + containerX)
			{
				//outside boundry, move to other side of container
				tempStar.x = containerX;
				tempStar.y = (Math.random() * containerHeight) + containerY;
			}
			else if (tempStar.x <= containerX)
			{
				//outside boundry, move to other side of container
				tempStar.x = containerWidth + containerX;
				tempStar.y = (Math.random() * containerHeight) + containerY;
			}
			//check Y boudries
			if (tempStar.y >= containerHeight + containerY)
			{
				//outside boundry, move to other side of container
				tempStar.x = (Math.random() * containerWidth) + containerX;
				tempStar.y = containerY;
			}
			else if (tempStar.y <= containerY)
			{
				//outside boundry, move to other side of container
				tempStar.x = (Math.random() * containerWidth) + containerX;
				tempStar.y = containerHeight + containerY;
			}
		}
		dustTile.drawTiles(graphics, drawList,true);
	}
}
