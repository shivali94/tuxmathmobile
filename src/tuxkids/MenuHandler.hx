
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
import com.eclecticdesignstudio.motion.actuators.FilterActuator;
import flash.geom.Point;
import flash.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.BitmapData;
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
import nme.geom.Matrix;
import nme.geom.Rectangle;
import nme.media.SoundChannel;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import tuxkids.MainMenu;
import tuxkids.SubLevelMenu;
import tuxkids.Main;

 /**
  *  Class for displaying menu and submenus 
  */
class MenuHandler extends Sprite
{
	/**
	 * Level 
	 */
	public var level:Int;
	/**
	 * Sublevel Instance
	 */
	public var sublevel:Int;
	var sublevelmenu:SubLevelMenu;									// Instance of sublevelmenu
	var main_menu_screen:MainMenu;									// Instance of main_menu_screen
	var background_nebula_image:Bitmap; 							// Used to show background nebula image 
	var nebula_gradient:Point;										// Used for calculating how much sprite should move with respect to planets sprite 
	// Used for displaying and animating galaxy
	var galaxy:Tilesheet;
	var galaxy_sprite:Sprite;
	var galaxy_gradient:Float;										//  Gradient for galaxy Image
	/**
	 * Used for stopping playing sound.
	 */
	public var sound_instance:SoundChannel;
	
	/**
	 * Constructor.
	 */										
	public function new() 
	{
		super();
		// Loading background image.
                var widthRatio:Float = Lib.current.stage.stageWidth/Main.ASSETS_WIDTH;
                var heightRatio:Float = Lib.current.stage.stageHeight/Main.ASSETS_HEIGHT;
		var matrix:Matrix = new Matrix();
                matrix.scale(widthRatio, heightRatio);
		var nebulaData:BitmapData = Assets.getBitmapData("assets/background/nebula.png");
		var scaledNebulaData:BitmapData = new BitmapData(Std.int(nebulaData.width*widthRatio),
			Std.int(nebulaData.height*heightRatio), true, 0x000000);
		scaledNebulaData.draw(nebulaData, matrix, null, null, true);	
		background_nebula_image = new Bitmap(scaledNebulaData);
		addChild(background_nebula_image);
		galaxy_sprite = new Sprite();
		addChild(galaxy_sprite);
		// Initializing main_menu_screen
		main_menu_screen = new MainMenu();
		
		// background_nebula_image
		nebula_gradient = new Point();
		nebula_gradient.x = (background_nebula_image.width - GameConstant.stageWidth) / (main_menu_screen.planets.width - GameConstant.stageWidth/2);
		nebula_gradient.y = (background_nebula_image.height - GameConstant.stageHeight) / (main_menu_screen.planets.width - GameConstant.stageWidth/2);
		   
		// Galaxy image
                var widthRatio:Float = Lib.current.stage.stageWidth/Main.ASSETS_WIDTH;
                var heightRatio:Float = Lib.current.stage.stageHeight/Main.ASSETS_HEIGHT;
		var matrix:Matrix = new Matrix();
                matrix.scale(widthRatio, heightRatio);
		var galaxyData:BitmapData = Assets.getBitmapData("assets/background/galaxy.png");
		var scaledGalaxyData:BitmapData = new BitmapData(Std.int(galaxyData.width*widthRatio),
			Std.int(galaxyData.height*heightRatio), true, 0x000000);
		scaledGalaxyData.draw(galaxyData, matrix, null, null, true);	
		galaxy = new Tilesheet(scaledGalaxyData);
		galaxy.addTileRect(new Rectangle(0, 0, galaxy.nmeBitmap.width, galaxy.nmeBitmap.height));
		galaxy_gradient = -(1 / (main_menu_screen.planets.width - GameConstant.stageWidth/2)) * 0.75;
		
		// Adding eventlistener 
		var scale:Float;
		var planet_x:Float = -10;
		main_menu_screen.addEventListener(Event.ENTER_FRAME, function(ev:Event) {
			if (main_menu_screen.planets.x == planet_x)	
					return;
			planet_x =  main_menu_screen.planets.x;
			background_nebula_image.x = planet_x * nebula_gradient.x;
			background_nebula_image.y = planet_x * nebula_gradient.y;
			scale = Math.pow((planet_x * galaxy_gradient),2) + 0.45;
			galaxy_sprite.graphics.clear();
			galaxy.drawTiles(galaxy_sprite.graphics, [((1-scale) * GameConstant.stageWidth) * 1.3, (1-scale) * GameConstant.stageHeight/8, 0, scale], false, Tilesheet.TILE_SCALE);
		});
		
		// Sublevel menu 
		sublevelmenu = new SubLevelMenu();
		//Centering it 
		sublevelmenu.x = GameConstant.stageWidth * 0.1;
		sublevelmenu.y = GameConstant.stageHeight * 0.1;
		//Back Button
		var back_button:Sprite = Button.button("BACK", 0xED1C1C, GameConstant.stageHeight/ 6);
		back_button.y = GameConstant.stageHeight - back_button.height;
		back_button.alpha = 0.7;
		// Adding stardust 
		addChild(GameConstant.star_dust);
		// Displaying Main menu 
		addChild(main_menu_screen);
		// Playing stardust
		GameConstant.star_dust.play();
	
		GameConstant.star_dust.register(main_menu_screen.planets);					// Registering planet sprite so that stardust move wih respect to it
		// Displaying sublevels 
		addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
			if (!Std.is(event.target, Planet))
				return;
				level = event.target.value;
				// Removing in order to increase performance while zooming and to solve crashing of app on iPad 3.
				main_menu_screen.information_sprite.removeChild(main_menu_screen.information_text);
				// Initializing star score of sublevels
				sublevelmenu.initializeScore(SavedData.score[level]);
				sound_instance.stop();
				GameConstant.star_dust.stop();								// Stoping stardust for better performance 
				Transition.zoomIn([sublevelmenu, back_button], [main_menu_screen], this);			// No need to remove stardust
				function temp_function(ev:Event)
				{
					GameConstant.star_dust.play();
					Transition.dispatch.removeEventListener(Transition.TRANSITION_COMPLETE, temp_function);
				}
				Transition.dispatch.addEventListener(Transition.TRANSITION_COMPLETE, temp_function); 
				/*     To be replaced with transition statement if we don't want any transitions 
				addChild(sublevelmenu);
				addChild(back_button);
				removeChild(main_menu_screen);	
				*/
			});
			
		//sublevel handler 
		addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
			if (Std.is(event.target, SubLevels))
			{
				sublevel = event.target.value;
				trace("Level selected is:" + (level + 1) + " and sublevel is: " + (sublevel + 1));
				//Starting game
				this.dispatchEvent( new Event("Start Game"));
			}
			if (Std.is(event.target.parent, SubLevels))
			{
				sublevel = event.target.parent.value;
				trace("Level selected is:" + (level + 1) + " and sublevel is: " + (sublevel + 1));
				// Starting game
				this.dispatchEvent( new Event("Start Game"));
			}
		});
			
		// Back button handler 
		back_button.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
				level = -1;                     // No vaid choice has been made
				GameConstant.star_dust.stop();							// Stoping stardust for better performance
				Transition.zoomIn([main_menu_screen], [sublevelmenu, back_button], this);
				// Waiting for transition to be finished 
				function temp_function(ev:Event)
				{
					sound_instance = GameConstant.background_sound.play(0, -1);
					GameConstant.star_dust.play();										// Playing stardust again
					main_menu_screen.information_sprite.addChild(main_menu_screen.information_text);
					Transition.dispatch.removeEventListener(Transition.TRANSITION_COMPLETE, temp_function);
				}
				Transition.dispatch.addEventListener(Transition.TRANSITION_COMPLETE, temp_function); 
				/*
				removeChild(sublevelmenu);
				removeChild(back_button);
				addChild(main_menu_screen);	
				*/
			});
	}
	
	/**
	 * This function is used to show updated star score when a game ends and player is redirected to sublevel menu screen again.
	 */
	public function refreshScore() {
		sublevelmenu.initializeScore(SavedData.score[level]);
	}
}
