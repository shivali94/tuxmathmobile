package tuxkids;
/**
 * ...
 * @author Deepak Aggarwal
 */

import nme.display.Sprite;
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
	/**
	 * Used for transition zoom effect 
	 */
	static var animation_sprite:Sprite;
	static public var dispatch:EventDispatcher;
	static public var TRANSITION_COMPLETE:String;
	/**
	 * Function for initializing transition.
	 */
	public static function intialize()
	{
		star_field = new StarField();
		animation_sprite = new Sprite();
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
		// Resetting star field.
		star_field.alpha = 0;
		star_field.visible = true;
		// Resetting animation sprite.
		animation_sprite.scaleX = animation_sprite.scaleY = 1;
		animation_sprite.visible = true;
		animation_sprite.alpha = 1;
		animation_sprite.x = animation_sprite.y = 0;
	
		// Removing all image and sprites that are to be remove and adding them to animation sprite. 
		for (x in 0...remove.length)
			animation_sprite.addChild(remove[x]);
		// Adding star field.
		Lib.current.addChild(star_field);
		// Adding animation sprite on the top of everything.
		Lib.current.addChild(animation_sprite);
		
		
		/*
		// Adding all images and sprites that are to be added
		for (x in 0...add.length)
			target.addChild(add[x]);
		
		// Capturing image for post transition
		
		pos_trans.draw(target);
		pos_image.scaleX = pos_image.scaleY = 2.5;
		pos_image.x = -GameConstant.stageWidth * (pos_image.scaleX-1) / 2;
		pos_image.y = -GameConstant.stageHeight * (pos_image.scaleY - 1) / 2;
		target.addChild(pos_image);
		*/
		
		
		//Animation
		// Zomming captured image. 
		var temp_instance = GameConstant.space_travel.play();						// starting space_travel time sound 
		Actuate.tween(animation_sprite, 1, { scaleX:2, scaleY:2, alpha:0 } ).onUpdate(function() {
			animation_sprite.x = -GameConstant.stageWidth * (animation_sprite.scaleX-1) / 2;
			animation_sprite.y = -GameConstant.stageHeight * (animation_sprite.scaleY - 1) / 2;
			star_field.alpha = 1 - animation_sprite.alpha;
		}).onComplete(function() {			
			// Removing all images and sprite from the animation sprite
				for (x in 0...remove.length)
					animation_sprite.removeChild(remove[x]);
			// Resetting animation sprite.
				animation_sprite.scaleX = animation_sprite.scaleY = 1;
				animation_sprite.visible = true;
				animation_sprite.alpha = 0;
				animation_sprite.x = animation_sprite.y = 0;
				
			Actuate.tween(star_field, 3, { } ).onComplete(function(){
				Actuate.tween(star_field, 0.5, { alpha:0 } ).onUpdate(function() { animation_sprite.alpha = 1 - star_field.alpha; } ).onComplete(function() { 
					Lib.current.removeChild(star_field); 
					temp_instance.stop();                                     // stoping space_transition sound 
					star_field.stop(); 
					});
				GameConstant.transition_end.play();
				Actuate.tween(animation_sprite, 2, { scaleX:1, scaleY:1 }).onUpdate(function() {
					animation_sprite.x = -GameConstant.stageWidth * (animation_sprite.scaleX-1) / 2;
					animation_sprite.y = -GameConstant.stageHeight * (animation_sprite.scaleY - 1) / 2;
				}).onComplete(function () {  
					for (x in 0...add.length)
						target.addChild(add[x]);
					dispatch.dispatchEvent(new Event(TRANSITION_COMPLETE));
				});
			});
			
			/*Doing it here so there is no slow down while animation.*/
			// Adding all images and sprites that are to be added
			for (x in 0...add.length)
				animation_sprite.addChild(add[x]);
			animation_sprite.scaleX = animation_sprite.scaleY = 2.5;
			animation_sprite.x = -GameConstant.stageWidth * (animation_sprite.scaleX-1) / 2;
			animation_sprite.y = -GameConstant.stageHeight * (animation_sprite.scaleY - 1) / 2;				
			// Adding animation sprite to stage
			Lib.current.addChild(animation_sprite);
			Lib.current.addChild(star_field);
		});
		star_field.play();	
	}
	
}