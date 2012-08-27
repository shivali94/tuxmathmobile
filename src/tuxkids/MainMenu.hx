
/*=======================================================================================================
												LICENSE 
  =======================================================================================================
  
				The contents of this file are subject to the Mozilla Public
				License Version 2.0 (the "License"); you may not use this file
				except in compliance with the License. You may obtain a copy of
				the License at http://www.mozilla.org/MPL/2.0/

				Software distributed under the License is distributed on an "AS
				IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
				implied. See the License for the specific language governing
				rights and limitations under the License.

				The Original Code is "Tuxmath"
				
				Copyright (C) 2012 by Tux4kids.  All Rights Reserved.
				Author : Deepak Aggarwal
  =======================================================================================================*/

package tuxkids;

/**
 * ...
 * @author Deepak Aggarwal
 */
import com.eclecticdesignstudio.motion.Actuate;
import nme.geom.Point;
import nme.geom.Rectangle;
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
import nme.utils.Timer;
import nme.events.TimerEvent;
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
	 * Array containing position of planet sprites
	 */
	public var planet_position:Array<Float>;
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
		planet_position = new Array<Float>();
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
			planet_position[x] = x_scale + temp.width / 2;
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
	// Variable for showing information
	public var information_sprite:Sprite;
	public var information_text:TextField;
	var information_text_format:TextFormat;
	var information_overlay:Bitmap;
	var update_timer:Timer;
	
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
	var velocity_limit:Float;    // Threshold value of velocity for terminate scrolling of sprite.
	/**
	 * Planet which is currently visible.
	 */
	var visible_planet_no:Int;
	/**
	 * Constructor
	 */
	public function new()
	{
		super();
		friction = 0.90;
		velocity_limit = 0.5 * GameConstant.stageWidth / 480;            // Taking 480 X 320 resolution as reference.
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
			animate_information();
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
		
		information_overlay = new Bitmap(Assets.getBitmapData("assets/overlay/overlay_white.png"));
		addChild(information_overlay);
		addChild(planets);
		information_sprite = new Sprite();
		addChild(information_sprite);
		initialize_information_sprite();
		
		//Code for updating information.
		update_timer = new Timer(500, 0);
		addEventListener(Event.ADDED_TO_STAGE, function(ev:Event) {
			update_timer.start();
		});
		addEventListener(Event.REMOVED_FROM_STAGE, function(ev:Event) {
			update_timer.stop();
		});
	}
	
	/**
	 * Function for updating information.
	 * @param	ev
	 */
	function update_information(ev:Event)
	{
		// Find fisrt planet which is visible 
		for (x in 0...8)
		{
			if (planets.x + planets.planet_position[x] > 0 )
			{
				visible_planet_no = x;
				break;
			}
		}
		// Checking planet(visible_plant_no and next planet) which is nearest to the center of screen.
		if ( Math.abs((planets.planet_position[visible_planet_no] + planets.x - GameConstant.stageWidth / 2) / (planets.planet_position[visible_planet_no + 1] + planets.x - GameConstant.stageWidth / 2)) < 1)
			visible_planet_no = visible_planet_no + 0;
		else
			visible_planet_no = visible_planet_no + 1;
			
		switch(visible_planet_no)
		{
			case 0 : information_text.text = "Addition questions";
			case 1 : information_text.text = "Subtraction questions";
			case 2 : information_text.text = "Addition and Subtraction questions";
			case 3 : information_text.text = "Multiplication questions";
			case 4 : information_text.text = "Multiplication and revision questions";
			case 5 : information_text.text = "Division questions";
			case 6 : information_text.text = "Division and revision questions";
			case 7 : information_text.text = "Factroid questions";
			case 8 : information_text.text = "All types of questions";
		}
		information_text.setTextFormat(information_text_format);
	}
	
	/**
	 * Function for animating information.
	 */
	function animate_information()
	{
		if (!update_timer.hasEventListener(TimerEvent.TIMER))
			update_timer.addEventListener(TimerEvent.TIMER, update_information);
		Actuate.tween(information_sprite, 1, { alpha:0 } )
		.onUpdate(function() {
			// Inorder to avoid distorted animation of fading out of information_overlay.
			if(information_overlay.alpha>=0.1)
				information_overlay.alpha = information_sprite.alpha;
		})
		.onComplete(function() {
			information_overlay.visible = true;
			Actuate.tween(information_sprite, 3, { alpha:1 } )
			.onUpdate(function() {
				information_overlay.alpha = information_sprite.alpha;
			})
			.onComplete(function() {
				Actuate.tween(information_overlay, 0.8, { alpha:0 } );
			});
		});
	}
	/**
	 * Function for initializing information sprite.
	 */
	function initialize_information_sprite()
	{
		information_text =  new TextField();
		information_text_format = new TextFormat('Arial', 30, 0xffffff);
		information_text_format.align = TextFormatAlign.CENTER;
		information_text = new TextField();
		information_text.text = "Slide across the screen and select a planet.";
		information_text.setTextFormat(information_text_format);
		var textSize:Float = GameConstant.stageWidth;                         //  Will cover 100% of button height
		// Setting size of text. 
		if (information_text.textWidth > textSize)
			while (information_text.textWidth > textSize)
			{
				information_text_format.size--;
				information_text.setTextFormat(information_text_format);
			}
		else
			while (information_text.textWidth < textSize)
			{
				information_text_format.size++;
				information_text.setTextFormat(information_text_format); 
			}
			
		information_text.width = GameConstant.stageWidth * 0.65 ;
		information_text.height = information_text.textHeight* 2.1;
		information_text.wordWrap = true;	
		information_text.selectable = false;

		// Setting position.
		information_text.y = GameConstant.stageHeight * 0.10;
		information_text.x = (GameConstant.stageWidth - information_text.textWidth) / 2;
		
		information_overlay.alpha = 0;
		information_overlay.visible = false;
		information_sprite.addChild(information_text);
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
