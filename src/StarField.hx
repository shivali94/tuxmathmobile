package ;

import nme.display.Sprite;
import nme.geom.Point;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

private class Star extends Sprite
	{
		private var d:Float; // distance from center
		private var r:Float ; // angle of travel in radians
		private var stageCenter:Point;
		private var speed:Float; // applies a random speed to stars so they do not all travel at the same speed.
		private static var acceleration:Float = 1.125;
		public function new()
		{
			super();
			this.alpha = 0;
			init();
		}
		public function play()
		{
			addEventListener(Event.ENTER_FRAME, update);
			stageCenter = new Point(GameConstant.stageWidth / 2, GameConstant.stageHeight / 2);
		}
		public function stop()
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}
 
		private function update(e:Event)
		{
			d*= acceleration + (speed*0.25);
			alpha= d/500; // fades in the stars as they get closer.
			x = stageCenter.x + Math.cos(r) * d/2;
			y = stageCenter.y + Math.sin(r) * d / 2;
			// loop star when it goes off the stage.
			if (x > stageCenter.x *2 || x < 0 || y > stageCenter.y *2 || y < 0) {
				init();
			}
		}	
		private function init()
		{
			// init values;
			r = Math.random() * 6;
			d = Math.random() * 150;
			speed = Math.random() * 0.0510;
			// draw circle
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawCircle(0, 0, speed * Lib.current.stage.stageHeight/30);
		}
	} 
	
class StarField  extends Sprite
{
	var stars:Array<Star>;
	public function new() 
	{
		super();
		stars = new Array<Star>();
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(0, 0, GameConstant.stageWidth, GameConstant.stageHeight);
		this.graphics.endFill();
		for(x in 0... cast GameConstant.stageHeight/2) {
				var s:Star = new Star();
				s.x = Math.random() * 1000;
				s.y = Math.random() * 650;
				addChild(s);
				stars.push(s);
			} 
	}
	public function play()
	{
		for (x in 0...stars.length)
		{
			stars[x].play();
		}
	}
	public function stop()
	{
		for (x in 0...stars.length)
		{
			stars[x].stop();
		}
	}
}