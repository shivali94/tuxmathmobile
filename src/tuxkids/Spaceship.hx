
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
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Shape;
import nme.display.Sprite;
import nme.Assets;
import nme.display.Bitmap;
import nme.Lib;
import nme.geom.Matrix;
import haxe.Timer;
import tuxkids.Main;

/**
 * ...
 * @author Deepak Aggarwal
 */

/**
 * Class for loading spaceship and showing laser.
 */
class Spaceship extends Sprite
{
	// For showing laser.
	var line:Shape;
	// For loading spaceship image.
	var spaceship:Bitmap;
	/**
	 * Constructor
	 */ 
	public function new() 
	{
		super();
		// Loading spaceship image.
                var widthRatio:Float = Lib.current.stage.stageWidth/Main.ASSETS_WIDTH;
                var heightRatio:Float = Lib.current.stage.stageHeight/Main.ASSETS_HEIGHT;
		var matrix:Matrix = new Matrix();
                matrix.scale(widthRatio, heightRatio);
		var spaceshipData:BitmapData = Assets.getBitmapData("assets/spaceship/spaceship.png");
		var scaledSpaceshipData:BitmapData = new BitmapData(Std.int(spaceshipData.width*widthRatio),
			Std.int(spaceshipData.height*heightRatio), true, 0x000000);
		scaledSpaceshipData.draw(spaceshipData, matrix, null, null, true);	
		spaceship = new Bitmap(scaledSpaceshipData);
		// Centering it.
		spaceship.y = (GameConstant.stageHeight - spaceship.height) / 2;
		// Ading it to the stage.
		addChild(spaceship);
	}
	/**
	 * Function used to show laser. <br>
	 * @param	x :- End x co-ordinate
	 * @param	y :- End y co-ordinate
	 */
	public function show_laser(x:Float,y:Float)
	{
		var line:Shape = new Shape();
		line.graphics.lineStyle(4, 0xFF0000);
		line.graphics.moveTo(spaceship.x + spaceship.width,spaceship.y + spaceship.height/2);
		line.graphics.lineTo(x, y);
		addChildAt(line,1);
		Timer.delay(function() { removeChild(line); }, 150);
	}

}
