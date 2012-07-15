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
	}
	public function new ()
	{
		super();
		starsArray = new Array<Dust>();
		drawList = new Array<Float>();
		starArrayLength = cast Lib.current.stage.stageWidth ;
		containerX = 0;
		containerY = 0;
		containerWidth = Lib.current.stage.stageWidth;
		containerHeight = Lib.current.stage.stageHeight;
		
		var shape = new Sprite();
		shape.graphics.clear();
		shape.graphics.beginFill(0x525252);
		shape.graphics.drawCircle(0, 0, 0.02810 * Lib.current.stage.stageHeight / 18);
		shape.graphics.endFill();
		// Creating dust
		createStarDust();
		// Getting bitmap data
		var dust_bitmapdata:BitmapData = new BitmapData(cast shape.width, cast shape.height);
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
	
	var index:Int;
	var tempStar:Dust;
	private function updateDust(ev:Event)
	{
		graphics.clear();
		// run for loop
		for(i in 0...starArrayLength)
		{
			index = i * 3;
			tempStar = starsArray[i];
			drawList[index] = tempStar.x += 0.2;
			drawList[index+1] = tempStar.y += 0 ;
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
