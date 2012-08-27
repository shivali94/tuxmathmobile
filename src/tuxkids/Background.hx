
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
import nme.display.Sprite;
import nme.Assets ;
import nme.display.Bitmap;
import nme.display.Tilesheet;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Deepak Aggarwal
 */

/**
 * Class used for initializing background when user play this game and answer questions.
 */
class Background extends Sprite
{
	var nebula1:Bitmap;														// Used for loading image of first nebula.
	var nebula2:Bitmap;														// Used for loading image of second nebula.
	var star_cloud1:Bitmap;													// For loading clouds.
	var star_cloud2:Bitmap;
	private var deltaMovement:Float;										// Delta movement for background animation.
	private var backroundScrollSpeed:Float;     							// background scrolling speed.
	private var levelInstance:Level;										// For holding instance level so that we can access diffTime value for time based animation.
	private var limitx:Float;												// For rotating sprite for endless scrolling.
	/**
	 * Constructor<br>
	 * @param	param :- Instance of level class for accessing diffTime for time based animation.
	 */
	public function new(param:Level) 
	{
		super();
		// Initializing bitmaps and adding them to stage.
		nebula1 = new Bitmap();
		nebula2 = new Bitmap();
		addChild(nebula1);
		addChild(nebula2);
		star_cloud1 = new Bitmap(Assets.getBitmapData("assets/background/cloud3.png"));
		star_cloud2 = new Bitmap();
		star_cloud2.bitmapData = star_cloud1.bitmapData;
		addChild( new Bitmap(Assets.getBitmapData("assets/background/star.png")));
		addChild(star_cloud1);
		addChild(star_cloud2);
		levelInstance = param;
		deltaMovement = 0.02;
		backroundScrollSpeed = 1 * deltaMovement;
		// Adding second cloud image behind first cloud image.
		star_cloud2.x = star_cloud1.width + star_cloud1.x;
		star_cloud1.alpha = star_cloud2.alpha = 0.8;
	}
	
	/**
	 * Function used for initializing background based on level and sublevel.		<br>
	 * @param	level :- Game Level
	 * @param	sublevel	:- Sublevel
	 */
	public  function initializeBackground(level:Int , sublevel:Int)
	{
		// Loading nebula Images based on level and placing then randomly.
		nebula1.bitmapData = Assets.getBitmapData("assets/background/nebula and fractals/galaxy_sprite_"+level+".png");
		nebula1.x = Lib.current.stage.stageWidth * (0.15 + 0.25 * Math.random());
		nebula1.y = Lib.current.stage.stageHeight * 0.1 * Math.random();
		nebula2.bitmapData = Assets.getBitmapData("assets/background/nebula and fractals/galaxy_sprite_"+(level+1)+".png");
		nebula2.x = Lib.current.stage.stageWidth * (0.65 + (Math.random() / 5));
		nebula2.y = Lib.current.stage.stageHeight * (0.6 + (0.15 * Math.random()));
		
		limitx = -star_cloud1.width;													// Initializing limitx value.
		// Loading clouds based on level.
		if(level <= 2){
			star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud1.png");
			star_cloud2.bitmapData = star_cloud1.bitmapData;
		}	
		else
			if(level <= 4){
				star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud2.png");
				star_cloud2.bitmapData = star_cloud1.bitmapData;
			}	
			else
				if(level <= 6){
					star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud3.png");
					star_cloud2.bitmapData = star_cloud1.bitmapData;
				}	
				else{
					star_cloud1.bitmapData = Assets.getBitmapData("assets/background/cloud4.png");
					star_cloud2.bitmapData = star_cloud1.bitmapData;
				}	
	}
	/**
	 * Function for scrolling background using time based animation.
	 */
	public function scrollBackground()
	{
		// Updating clouds. 
		star_cloud1.x -= levelInstance.diffTime * backroundScrollSpeed;  
		star_cloud2.x -= levelInstance.diffTime * backroundScrollSpeed;  
		
		// Checking Image position so that we can have infinite scrolling background.
		if (star_cloud1.x <= limitx) 
			star_cloud1.x = star_cloud2.x + star_cloud2.width;									// Placing sprite.
		else 
			if (star_cloud2.x <= limitx) 			
				star_cloud2.x = star_cloud1.x + star_cloud1.width;								// Placing sprite.
	}
	
}