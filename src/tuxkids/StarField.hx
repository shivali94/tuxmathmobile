package tuxkids;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Shape;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */ 
/**
 * Static class for initializing all parameters
 */
private class StarConstant 
{
	public static var stageCenter:Point;
	public static var acceleration:Float = 1.035;
	public static var shape:Sprite;
	public static function initialize()
	{
		stageCenter = new Point(GameConstant.stageWidth / 2, GameConstant.stageHeight / 2);
		var size = 0.04010 * GameConstant.stageHeight / 15;
		shape = new Sprite();
		shape.graphics.clear();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.drawCircle(0, 0, size);
		shape.graphics.endFill();
	}
}
/**
 * Class which contains various data of single star
 */
private class Star
	{
		public var d:Float; // distance from center
		public var r:Float ; // angle of travel in radians
		public var speed:Float; // applies a random speed to stars so they do not all travel at the same speed.
		public function new()
		{
			r = Math.random() * 6;
			d = Math.random() * 150;
			speed = Math.random() * 0.0510;
		}	
	} 
	
/**
 * Class for creating starfield and animating it 
 */
class StarField  extends Sprite
{
	var stars:Array<Star>;										// For holding stars
	var starTile:Tilesheet;										// For blitting stars
	var drawList:Array<Float>;		
	var starfieldSprite:Sprite;
	var no_of_stars:Int;										// Total numebr of stars 
	/**
	 * Constructor
	 */
	public function new() 
	{
		super();
		// Initializing constants
		StarConstant.initialize();
		stars = new Array<Star>();
		drawList = new Array<Float>();
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(0, 0, GameConstant.stageWidth, GameConstant.stageHeight);
		this.graphics.endFill();
		// Getting bitmap data
		var star_bitmapdata:BitmapData = new BitmapData(cast StarConstant.shape.width, cast StarConstant.shape.height);
		star_bitmapdata.draw(StarConstant.shape);
		//Initializing starTile
		starTile = new Tilesheet(star_bitmapdata);
		starTile.addTileRect(new Rectangle(0, 0, StarConstant.shape.width, StarConstant.shape.height));
		starfieldSprite = new Sprite();
		addChild(starfieldSprite);
		no_of_stars = cast GameConstant.stageWidth / 2; 
		var index:Int;
		for (x in 0...no_of_stars) {
				index = x * 4;
				var s:Star = new Star();
				// Initializing x and y co-ordinate of star.
				drawList[index] = Math.random() * 1000;
				drawList[index+1] = Math.random() * 650;
				stars.push(s);
			} 
	}
	/**
	 * Function for playing animation.
	 */
	public function play()
	{
		addEventListener(Event.ENTER_FRAME, update);
	}
	/**
	 * Function for stoping animation.
	 */
	public function stop()
	{
		removeEventListener(Event.ENTER_FRAME, update);
	}
	
	var index:Int;
	var star:Star;
	/**
	 * For updating starfield
	 * @param	ev
	 */
	private function update(ev:Event)
	{
		starfieldSprite.graphics.clear();
		for (x in 0...no_of_stars)
		{
			index = 4 * x;
			star = stars[x];
			star.d *= StarConstant.acceleration + (star.speed * 0.25);
			// Updating stars positions 
			drawList[index] = StarConstant.stageCenter.x + Math.cos(star.r) * star.d/2;
			drawList[index + 1] = StarConstant.stageCenter.y + Math.sin(star.r) * star.d / 2;
			//drawList[index + 2] = 0;
			drawList[index + 3] = star.d/500; // fades in the stars as they get closer.
			// loop star when it goes off the stage.
			if (drawList[index] > StarConstant.stageCenter.x *2 || drawList[index] < 0 || drawList[index +1] > StarConstant.stageCenter.y *2 || drawList[index+1] < 0) {
				star.r = Math.random() * 6;
				star.d = Math.random() * 150;
				star.speed = Math.random() * 0.0510;
			}
		}
		starTile.drawTiles(starfieldSprite.graphics, drawList, true,Tilesheet.TILE_ALPHA);
	}
}