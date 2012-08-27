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

import java.awt.Image;
import java.awt.image.*;
import org.imgscalr.*;
import javax.imageio.*;
import java.io.File;

public class Deploy{
	
	static void saveImage(String saveas, BufferedImage resized)
	{
		try{
			File outfile = new File(saveas);
			ImageIO.write(resized,"png",outfile);
		}
		catch( Exception ex){
			System.out.println("Unable to save resized Image");
		}
	}
	static BufferedImage loadImage(String target)
	{
		try{
			BufferedImage image= ImageIO.read(new File(target));
			return image;
		}
		catch(Exception ex){
			System.out.println("Unable to open file");
			return null;
		}
	}
	static void resizeBackground(int res_width, int res_height)
	{
		res_height = (int) (res_width*1.0/2048 * 1536);								// maintaining aspect ratio

		// Resizing star
		BufferedImage img = loadImage("assets/background/star.png");    // Loading Image 
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,res_width,res_height);
		resized = Scalr.crop(resized,res_width,res_height);      							// croping it 
		saveImage("../assets/background/star.png",resized);   			// saving image  

		for(int i=1; i<= 4;i++)
		{
			// Resizing star_cloud
			img = loadImage("assets/background/cloud"+i+".png");    // Loading Image 
			resized= Scalr.resize(img,Scalr.Method.ULTRA_QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,res_width,res_height);
			resized = Scalr.crop(resized,res_width,res_height);      							// croping it 
			saveImage("../assets/background/cloud"+i+".png",resized);   			// saving image 
		}

		
		// Resizing galaxy image
		img = loadImage("assets/background/galaxy.png");    // Loading Image 
		resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,res_width,res_height);
		resized = Scalr.crop(resized,res_width,res_height);      							// croping it 
		saveImage("../assets/background/galaxy.png",resized);   			// saving image 
		
		// Resizing nebula
		img = loadImage("assets/background/nebula.png");    // Loading Image 
		resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,(int) (res_width*1.2),(int) (res_height*1.02));
		resized = Scalr.crop(resized,(int) (res_width*1.2),(int) (res_height*1.02));      							// croping it 
		saveImage("../assets/background/nebula.png",resized);   			// saving image 

		float ratio = (res_width* 1.0f)/2048;
		// Resizing small nebula
		for(int i=1; i<= 10;i++)
		{
			img = loadImage("assets/background/nebula and fractals/galaxy_sprite_"+i+".png");    // Loading Image 
			resized= Scalr.resize(img,Scalr.Method.ULTRA_QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,(int)(img.getWidth() * ratio) , (int)(img.getHeight() * ratio)); 
			saveImage("../assets/background/nebula and fractals/galaxy_sprite_"+i+".png",resized);   			// saving image
		} 

		// Resizing loading screen.
		
		img = loadImage("assets/background/loading/loading_screen.png");    // Loading Image 
		resized= Scalr.resize(img,Scalr.Method.ULTRA_QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,(int)(img.getWidth() * ratio) , (int)(img.getHeight() * ratio)); 
		saveImage("../assets/background/loading/loading_screen.png",resized); 
		
		// Resizing overlays
		img = loadImage("assets/overlay/overlay_white.png");    // Loading Image 
		resized= Scalr.resize(img,Scalr.Method.ULTRA_QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,(int)(img.getWidth() * ratio) , (int)(img.getHeight() * ratio)); 
		saveImage("../assets/overlay/overlay_white.png",resized); 
		
		img = loadImage("assets/overlay/overlay_red.png");    // Loading Image 
		resized= Scalr.resize(img,Scalr.Method.ULTRA_QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,(int)(img.getWidth() * ratio) , (int)(img.getHeight() * ratio)); 
		saveImage("../assets/overlay/overlay_red.png",resized); 

	}
	
	static void credits(int res_width, int res_height)
	{
		BufferedImage img = loadImage("assets/credits/credits.png");    // Loading Image 
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,res_width,res_height);
		resized = Scalr.crop(resized,res_width,res_height);      							// croping it 
		saveImage("../assets/credits/credits.png",resized);   			// saving image 
	}
	static void resizeSpaceship(int res_width, int res_height)
	{
		BufferedImage img = loadImage("assets/spaceship/spaceship.png");    		// Loading Image 
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,(int) (res_width * 0.43) ,res_height);				// Spaceship covers 43% of screen width 
		saveImage("../assets/spaceship/spaceship.png",resized);   					// saving image 
	}
	
	static void resizeAsteroid(int res_width, int res_height)
	{
		int x;
		for(x=0;x<3;x++)
		{
			BufferedImage img = loadImage("assets/asteroid/asteroid"+x+".png"); 		   		// Loading Image 
			BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,(int)(res_height/3) ,(int) (res_height/3));					// asteroids will be 1/3rd of the screen height 
			saveImage("../assets/asteroid/asteroid"+x+".png",resized);   					// saving image 
		}
			//Resizing small asteroids 
			BufferedImage img = loadImage("assets/asteroid/small_asteroid.png"); 		   		// Loading Image 
			BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,(int)(res_height/4) ,(int) (res_height/4));					// asteroids will be 1/4th of the screen height 
			saveImage("../assets/asteroid/small_asteroid.png",resized);   					// saving image 
			
			//Resizing small asteroids 
			img = loadImage("assets/asteroid/asteroid_pieces.png"); 		   		// Loading Image 
			x = (int)((res_height*1.0/1536)* img.getWidth() * 0.9);
			resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC, x, x);					
			saveImage("../assets/asteroid/asteroid_pieces.png",resized);   					// saving image 
	}
	
	static void resizeExplosion(int res_width, int res_height)
	{
		BufferedImage img = loadImage("assets/explosion/even_frame.png"); 		   		// Loading Image 
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,(int)(res_height*1.172) ,((int)(res_height * 1.172)));		 
		saveImage("../assets/explosion/even_frame.png",resized);   					// saving image 
		
		img = loadImage("assets/explosion/odd_frame.png"); 		   		// Loading Image 
		resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,(int)(res_height*1.172) ,((int)(res_height * 1.172)));		 
		saveImage("../assets/explosion/odd_frame.png",resized);   					// saving image 
	}
	
	static void resizePlanet(int res_width, int res_height)
	{
		float ratio = (float) res_height/1536;
		int i;
		
		// Resizing sun
		BufferedImage sun_img = loadImage("assets/planet/sun.png");    
			int sun_size = (int) (sun_img.getHeight()*ratio);
			BufferedImage resized_sun= Scalr.resize(sun_img,Scalr.Method.QUALITY,            
				Scalr.Mode.AUTOMATIC  ,(int) (sun_img.getWidth()*ratio)  ,(int) (sun_img.getHeight()*ratio));
			saveImage("../assets/planet/sun.png",resized_sun);   	
		
		// Resizing Planets 
		for(i =0;i<=8;i++)
		{
			BufferedImage planet_img = loadImage("assets/planet/planet"+i+".png");    // Loading Image 
			int planet_size = (int) (planet_img.getHeight()*ratio);
			BufferedImage resized_planet= Scalr.resize(planet_img,Scalr.Method.QUALITY,            	// resizing image
				Scalr.Mode.AUTOMATIC,planet_size,planet_size);
			saveImage("../assets/planet/planet"+i+".png",resized_planet);   			// saving image 
		}
		
		//for Star
		BufferedImage star_img = loadImage("assets/star.png");    // Loading Image 
		int star_size = (int) (res_height * 0.056);                            // It will be 5.6% of the stage height 
		BufferedImage resized_star= Scalr.resize(star_img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,star_size,star_size);
		saveImage("../assets/star.png",resized_star);   			// saving image 
		// Empty star
		star_img = loadImage("assets/empty_star.png");                               // It will be 5.6% of the stage height 
		resized_star= Scalr.resize(star_img,Scalr.Method.QUALITY,           
			Scalr.Mode.AUTOMATIC,star_size,star_size);
		saveImage("../assets/empty_star.png",resized_star);   			
	}
	
	public static void main( String args[])
	{
		int res_width, res_height ;
		if(args.length<2)
		{
			System.out.println("Please provide correct arguments");
			System.exit(0);
		}
		res_width=Integer.parseInt(args[0]);
		res_height=Integer.parseInt(args[1]);
		resizeBackground(res_width,res_height);
		credits(res_width,res_height);
		resizeSpaceship(res_width,res_height);
		resizeAsteroid(res_width,res_height);
		resizePlanet(res_width,res_height);
		resizeExplosion(res_width,res_height);
	}
}