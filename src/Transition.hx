package ;
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
class Transition 
{
	static var star_field:StarField;
	static var capture:BitmapData;
	static public var dispatch:EventDispatcher;
	static public var TRANSITION_COMPLETE:String;
	public static function intialize()
	{
		star_field = new StarField();
		capture = new BitmapData(GameConstant.stageWidth, GameConstant.stageHeight);
		dispatch = new EventDispatcher();
		TRANSITION_COMPLETE = "transition completed";
	}
	public static function zoomIn(add:Array<Dynamic>,remove:Array<Dynamic>,target:Dynamic) 
	{
		star_field.alpha = 1;
		star_field.visible = true;
		capture.draw(Lib.current.stage);
		var pre_image:Bitmap = new Bitmap(capture);
		// Removing all image and sprites that are to be remove 
		for (x in 0...remove.length)
			target.removeChild(remove[x]);
		// Adding all images and sprites that are to be added
		for (x in 0...add.length)
			target.addChild(add[x]);
		
		// Capturing image for post transition
		var pos_trans:BitmapData = new BitmapData(target.width, target.height);
		pos_trans.draw(target);
		var pos_image:Bitmap = new Bitmap(pos_trans);
		pos_image.scaleX = pos_image.scaleY = 2.5;
		pos_image.x = -GameConstant.stageWidth * (pos_image.scaleX-1) / 2;
		pos_image.y = -GameConstant.stageHeight * (pos_image.scaleY - 1) / 2;
		target.addChild(pos_image);
		
		//Adding starfield 
		target.addChild(star_field);
		//Adding captured screen
		target.addChild(pre_image);
		//Animation
		// Zomming captured image. 
		var temp_instance = GameConstant.space_travel.play();						// starting space_travel time sound 
		Actuate.tween(pre_image, 1, { scaleX:3, scaleY:3, alpha:0 } ).onUpdate(function() {
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