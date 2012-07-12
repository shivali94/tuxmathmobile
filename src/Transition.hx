package ;
import nme.display.Bitmap;

/**
 * ...
 * @author Deepak Aggarwal
 */

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.Lib;
import com.eclecticdesignstudio.motion.Actuate;
class Transition 
{
	static var star_field:StarField;
	static var capture:BitmapData;
	public static function intialize()
	{
		star_field = new StarField();
		capture = new BitmapData(GameConstant.stageWidth, GameConstant.stageHeight);
	}
	public static function zoomIn(add:Array<Dynamic>,remove:Array<Dynamic>,target:Dynamic) 
	{
		star_field.alpha = 1;
		capture.draw(Lib.current.stage);
		var image:Bitmap = new Bitmap(capture);
		// Removing all image and sprites that are to be remove 
		for (x in 0...remove.length)
			target.removeChild(remove[x]);
		// Adding all images and sprites that are to be added
		for (x in 0...add.length)
			target.addChild(add[x]);
		//Adding starfield 
		var star_field = new StarField();
		target.addChild(star_field);
		//Adding captured screen
		target.addChild(image);
		target.scaleX = target.scaleY = 5;
		target.x = -GameConstant.stageWidth * (target.scaleX-1) / 2;
		target.y = -GameConstant.stageHeight * (target.scaleY - 1) / 2;
		
		//Animation
		// Zomming captured image. 
		Actuate.tween(image, 1, { scaleX:20, scaleY:20, alpha:0 } ).onUpdate(function() {
			image.x = -GameConstant.stageWidth * (image.scaleX-1) / 2;
			image.y = -GameConstant.stageHeight * (image.scaleY - 1) / 2;
		}).onComplete(function() {			
			// Removing captured image 
			target.removeChild(image);
			// Zooming out target 
			Actuate.tween(target, 4.0, { scaleX:1, scaleY:1 } ).onUpdate(function() {
				target.x = -GameConstant.stageWidth * (target.scaleX-1) / 2;
				target.y = -GameConstant.stageHeight * (target.scaleY-1) / 2;
			});
			// Fading starfield 
			Actuate.tween(star_field, 4.5, { alpha:0 } ).onComplete(function() { target.removeChild(star_field); star_field.stop(); } );
		});
		star_field.play();
		
	}
	
}