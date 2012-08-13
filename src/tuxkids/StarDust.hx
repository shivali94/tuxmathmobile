package tuxkids;

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

/**
 * Class for displaying spacedust  
 */
class StarDust extends Sprite
{
	private var drawList:Array<Float>;
	private var starArrayLength:Int;
	private var containerX:Int;
	private var containerY:Int;
	private var containerWidth:Int;
	private var containerHeight:Int;
	private var dustTile:Tilesheet;
	private var update_vector:Point;						// Used with accelerometer for giving y velocity according to device orientation 
	private var register_sprite:Dynamic;					// Used for stardust movement effect with respect to a sprite
	private var register_sprite_old_x:Float;
	private var parallax_factor:Float;						// Used for parallax effect
	/**
	 * Creating stardust.
	 */
	private function createStarDust()
	{	
		for (x in 0...starArrayLength)
		{
			index = x * 3;
			drawList[index] = (Math.random() * containerWidth ) + containerX;
			drawList[index+1] = (Math.random() * containerHeight ) + containerY;
		}
		update_vector = new Point();
		update_vector.x = 0.4;          //x = 0.2 * cos(0)^2
		update_vector.y = 0;			 //y = 0.2 * sin(0)^2

	}
	
	/**
	 * Constructor
	 */
	public function new ()
	{
		super();
		drawList = new Array<Float>();
		starArrayLength = cast GameConstant.stageWidth * 0.8;
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
	/**
	 * Start playing stardust.
	 */
	public function play()
	{
		if(!hasEventListener(Event.ENTER_FRAME))				// In order to avois mutiple addition of events
		addEventListener(Event.ENTER_FRAME, updateDust);
	}
	/**
	 * Stop playing stardust.
	 */
	public function stop()
	{
		if(hasEventListener(Event.ENTER_FRAME))				// Remove if only is added in order to avoid errors
		removeEventListener(Event.ENTER_FRAME, updateDust);
	}
 
	/**
	 * Function used to register sprite so that star dust scroll or move with it . <br>
	 * @param	param :- Sprite to be register.
	 */
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
	var delta:Float;
	#if !flash
		var temp:Acceleration;
	#end
	/**
	 * Function for updating stardust
	 * @param	ev
	 */
	private function updateDust(ev:Event)
	{
		// Clearing everything.
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
		// Updating position 
		for(i in 0...starArrayLength)
		{
			index = i * 3;
			delta *= parallax_factor;                                          // Used for producing parallax effect
			drawList[index] += delta;         
			drawList[index + 1] += update_vector.y;
			//Star boundres
			//check X boudries
			if (drawList[index] >= containerWidth + containerX)
			{
				//outside boundry, move to other side of container
				drawList[index] = containerX;
				drawList[index + 1] = (Math.random() * containerHeight) + containerY;
			}
			else if (drawList[index]<= containerX)
			{
				//outside boundry, move to other side of container
				drawList[index] = containerWidth + containerX;
				drawList[index+1] = (Math.random() * containerHeight) + containerY;
			}
			//check Y boudries
			if (drawList[index+1] >= containerHeight + containerY)
			{
				//outside boundry, move to other side of container
				drawList[index] = (Math.random() * containerWidth) + containerX;
				drawList[index+1] = containerY;
			}
			else if (drawList[index+1] <= containerY)
			{
				//outside boundry, move to other side of container
				drawList[index] = (Math.random() * containerWidth) + containerX;
				drawList[index+1] = containerHeight + containerY;
			}
		}
		// Drawing stars
		dustTile.drawTiles(graphics, drawList,true);
	}
}
