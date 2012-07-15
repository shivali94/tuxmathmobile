package ;

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
private class StarConstant 
{
	public static var stageCenter:Point;
	public static var acceleration:Float = 1.035;
	public static var shape:Sprite;
	public static function initialize()
	{
		stageCenter = new Point(GameConstant.stageWidth / 2, GameConstant.stageHeight / 2);
		var size = 0.04010 * GameConstant.stageHeight / 10;
		shape = new Sprite();
		shape.graphics.clear();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.drawCircle(0, 0, size);
		shape.graphics.endFill();
	}
}
private class Star
	{
		public var d:Float; // distance from center
		public var r:Float ; // angle of travel in radians
		public var speed:Float; // applies a random speed to stars so they do not all travel at the same speed.
		public var x:Float;
		public var y:Float;
		public function new()
		{
			r = Math.random() * 6;
			d = Math.random() * 150;
			speed = Math.random() * 0.0510;
			x = 0;
			y = 0;
		}	
	} 
	
class StarField  extends Sprite
{
	var stars:Array<Star>;
	var starTile:Tilesheet;
	var drawList:Array<Float>;
	var starfieldSprite:Sprite;
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
		for(x in 0...cast GameConstant.stageWidth/2) {
				var s:Star = new Star();
				s.x = Math.random() * 1000;
				s.y = Math.random() * 650;
				stars.push(s);
			} 
	}
	public function play()
	{
		addEventListener(Event.ENTER_FRAME, update);
	}
	public function stop()
	{
		removeEventListener(Event.ENTER_FRAME, update);
	}
	
	var index:Int;
	public function update(ev:Event)
	{
		var star;
		starfieldSprite.graphics.clear();
		for (x in 0...cast GameConstant.stageWidth/2)
		{
			index = 4 * x;
			star = stars[x];
			star.d*= StarConstant.acceleration + (star.speed*0.25);
			drawList[index] = star.x = StarConstant.stageCenter.x + Math.cos(star.r) * star.d/2;
			drawList[index + 1] = star.y = StarConstant.stageCenter.y + Math.sin(star.r) * star.d / 2;
			//drawList[index + 2] = 0;
			drawList[index + 3] = star.d/500; // fades in the stars as they get closer.
			// loop star when it goes off the stage.
			if (star.x > StarConstant.stageCenter.x *2 || star.x < 0 || star.y > StarConstant.stageCenter.y *2 || star.y < 0) {
				star.r = Math.random() * 6;
				star.d = Math.random() * 150;
				star.speed = Math.random() * 0.0510;
			}
		}
		starTile.drawTiles(starfieldSprite.graphics, drawList, true,Tilesheet.TILE_ALPHA);
	}
}