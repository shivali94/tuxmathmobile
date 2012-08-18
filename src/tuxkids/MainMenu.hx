package tuxkids;

/**
 * ...
 * @author Deepak Aggarwal
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

/**
 * Class for loading planet images there value
 */
class Planet extends Sprite {
	/**
	 * Value of planet/
	 */
	public var value:Int;
	/**
	 * Used for blitting planets.
	 */
	var tileplanet:Tilesheet;
	/**
	 * Constructor. <br>
	 * @param	val: Value of planet.
	 */
	public function new (val:Int)
	{
		super();
		// Adding planets 
		tileplanet = new Tilesheet(Assets.getBitmapData("assets/planet/planet" + val + ".png"));
		tileplanet.addTileRect(new Rectangle(0, 0, tileplanet.nmeBitmap.width, tileplanet.nmeBitmap.height));
		tileplanet.drawTiles(graphics, [0, 0, 0]);
		value = val;
		tileplanet = null;															// Releasing memory
	}
}

private class Planets extends Sprite 
{
	/**
	 * For keeping tab on x dimension of sprite.
	 */
	public var x_scale:Int;
	/**
	 * Constructor.
	 */
	public function new ()
	{
		super();
		// Distance between two adjacent planets  
		var distance:Int = cast GameConstant.stageWidth / 4;
		x_scale = 0;                              						 // For keeping tab on x dimension of sprite 
		// First displaying sun
		var sun = new Bitmap(Assets.getBitmapData("assets/planet/sun.png"));
		x_scale = cast sun.width;
		sun.x = 0;
		sun.y = (GameConstant.stageHeight - sun.height) / 2;
		addChild(sun);
		// Adding planets
		for (x in 0...9)
		{
			x_scale += distance;
			var temp = new Planet(x);
			temp.x = x_scale;
			temp.y = (GameConstant.stageHeight - temp.height) / 2;     // Puting it in middle
			x_scale += cast temp.width;
			addChild(temp);
 		}
	}
}

/**
 * Class for displaying main menu which contains planets.
 */
class MainMenu extends Sprite
{
	var start_x:Int;
	var stop_x:Int;
	var start_time:Int;
	var stop_time:Int;
	var friction:Float;
	/**
	 * Holding all planets.
	 */
	public var planets:Planets;
	var velocity:Float;
	var velocity_limit:Float;    // Threshold value of velocity for terminate scrolling of sprite 
	public function new()
	{
		super();
		friction = 0.90;
		velocity_limit = 0.5 * GameConstant.stageWidth / 480;            // Taking 480 X 320 resolution as reference point 
		planets = new Planets();
		// Scrolling rectangles
		var bounds:Rectangle = new Rectangle( -planets.x_scale + GameConstant.stageWidth/2, 0, planets.x_scale-GameConstant.stageWidth/2, 0);
		// Necessary so that sprite could be dragged easily 
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0x000000);
		shape.graphics.drawRect(0, 0, GameConstant.stageWidth, GameConstant.stageHeight);
		shape.graphics.endFill();
		shape.alpha = 0;
		addChild(shape);
		
		  // For sprite scrolling 
		addEventListener(MouseEvent.MOUSE_DOWN, function(ev:MouseEvent) {
			planets.startDrag(false, bounds);
			start_x = ev.target.mouseX;
			start_time = Lib.getTimer();
			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, startMove);
		});
		addEventListener(MouseEvent.MOUSE_UP, function(ev:MouseEvent) {
			planets.stopDrag();
			stop_time = Lib.getTimer();
			stop_x = ev.target.mouseX;
			// Calculating velocity of sprite 
			velocity =  (stop_x - start_x) / GameConstant.stageWidth / (stop_time - start_time) * 25000 ;
			this.addEventListener(Event.ENTER_FRAME, startMove);
		}); 
		addEventListener(MouseEvent.MOUSE_OUT, function(ev:MouseEvent) {
			planets.stopDrag();
			stop_time = Lib.getTimer();
			stop_x = ev.target.mouseX;
			// Calculating velocity of sprite 
			velocity =  (stop_x - start_x) / GameConstant.stageWidth / (stop_time - start_time) * 25000 ;
			this.addEventListener(Event.ENTER_FRAME, startMove);
		});
		addChild(planets);
	}
	
	/**
	 * Function for moving sprite according  to the velocity possed by it.
	 * @param	ev
	 */
	private function startMove(ev:Event)
	{
		// Function for checking if velocity false below threshold value of velocity 
		if ( Math.abs(velocity) <= velocity_limit ) {
			this.removeEventListener(Event.ENTER_FRAME, startMove);
			return;
		}
		// Limits imposed on the movement of sprite 
		if (planets.x < -(planets.x_scale- GameConstant.stageWidth + velocity)  || planets.x + velocity >= 0 ) {
			this.removeEventListener(Event.ENTER_FRAME, startMove);
			return;
		}
		// Updating position of sprite 
		planets.x += velocity;
		// Decreasing velocity 
		velocity *= friction;
	}
}
