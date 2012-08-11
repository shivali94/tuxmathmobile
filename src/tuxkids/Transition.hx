package tuxkids;
/**
 * ...
 * @author Deepak Aggarwal
 */

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.Lib;
import nme.events.EventDispatcher;
import nme.events.Event;
import com.eclecticdesignstudio.motion.Actuate;
/**
 * Class used for transition effect
 */
class Transition 
{
	static var star_field:StarField;
	static var capture:BitmapData;
	static var pre_image:Bitmap ;
	static var pos_trans:BitmapData;
	static var pos_image:Bitmap;
	static public var dispatch:EventDispatcher;
	static public var TRANSITION_COMPLETE:String;
	/**
	 * Function for initializing transition.
	 */
	public static function intialize()
	{
		star_field = new StarField();
		capture = new BitmapData(GameConstant.stageWidth, GameConstant.stageHeight);
		pre_image = new Bitmap(capture);
		pos_trans = new BitmapData(GameConstant.stageWidth, GameConstant.stageHeight);
		pos_image = new Bitmap(pos_trans);
		dispatch = new EventDispatcher();
		TRANSITION_COMPLETE = "transition completed";
	}
	/**
	 * Function for showing zoomIn effect. <br>
	 * @param	add :- Sprites to be added.
	 * @param	remove :- Sprites to be removed.
	 * @param	target :- target sprite.
	 */
	public static function zoomIn(add:Array<Dynamic>,remove:Array<Dynamic>,target:Dynamic) 
	{
		star_field.alpha = 1;
		star_field.visible = true;
		capture.draw(Lib.current.stage);
		// Removing all image and sprites that are to be remove 
		for (x in 0...remove.length)
			target.removeChild(remove[x]);
		// Adding all images and sprites that are to be added
		for (x in 0...add.length)
			target.addChild(add[x]);
		
		// Capturing image for post transition
		
		pos_trans.draw(target);
		pos_image.scaleX = pos_image.scaleY = 2.5;
		pos_image.x = -GameConstant.stageWidth * (pos_image.scaleX-1) / 2;
		pos_image.y = -GameConstant.stageHeight * (pos_image.scaleY - 1) / 2;
		target.addChild(pos_image);
		
		//Adding starfield 
		target.addChild(star_field);
		//Adding captured screen
		pre_image.visible = true;
		pre_image.scaleX = pre_image.scaleY = 1;
		pre_image.x = pre_image.y = 0;
		pre_image.alpha = 1;
		target.addChild(pre_image);
		
		//Animation
		// Zomming captured image. 
		var temp_instance = GameConstant.space_travel.play();						// starting space_travel time sound 
		Actuate.tween(pre_image, 1.5, { scaleX:3, scaleY:3, alpha:0 } ).onUpdate(function() {
			pre_image.x = -GameConstant.stageWidth * (pre_image.scaleX-1) / 2;
			pre_image.y = -GameConstant.stageHeight * (pre_image.scaleY - 1) / 2;
		}).onComplete(function() {			
			// Removing captured image 
			target.removeChild(pre_image);
			// Fading starfield 
			Actuate.tween(star_field, 3, { } ).onComplete(function(){
				Actuate.tween(star_field, 0.5, { alpha:0 } ).onComplete(function() { 
					target.removeChild(star_field); 
					temp_instance.stop();                                     // stoping space_transition sound 
					star_field.stop(); } );
					GameConstant.transition_end.play();
					Actuate.tween(pos_image, 2, { scaleX:1, scaleY:1 }).onUpdate(function() {
						pos_image.x = -GameConstant.stageWidth * (pos_image.scaleX-1) / 2;
						pos_image.y = -GameConstant.stageHeight * (pos_image.scaleY - 1) / 2;
					}).onComplete(function () {  
						target.removeChild(pos_image); 
						dispatch.dispatchEvent(new Event(TRANSITION_COMPLETE));
					});
			});
		});
		star_field.play();	
	}
	
}