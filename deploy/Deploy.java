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
		float sub_level_time= 3.0f;                   // time for which background will move in minutes 
		float delta_movement=0.02f;                   // pixel at will move in one frame for avoiding flickering. (1/20 second- persistence of vision)
		int width;
		int height;
		int no_of_images;
		
		// Calculating height and width 
		height= (int) res_height ;
		width= (int) ((sub_level_time*60*1000)*delta_movement) +res_width;  
		no_of_images = width / res_width;
		BufferedImage img = loadImage("assets/background/background_space.png");    // Loading Image 
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,width,height);
		int x;
		for(x=0;x<no_of_images;x++)
		{
			BufferedImage temp = Scalr.crop(resized,x*res_width,0,res_width,res_height);     // croping it 
			saveImage("../assets/background/background_space"+x+".png",temp);   			// saving image 
		}
	}
	static void resizeMainBackground(int res_width, int res_height)
	{
		BufferedImage img = loadImage("assets/background/main_background.png");    // Loading Image 
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,res_width,res_height);
		resized = Scalr.crop(resized,res_width,res_height);      							// croping it 
		saveImage("../assets/background/main_background.png",resized);   			// saving image 
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
		BufferedImage img = loadImage("assets/asteroid/asteroid.png"); 		   		// Loading Image 
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,(int)(res_height/3) ,(int) (res_height/3));					// asteroids will be 1/3rd of the screen height 
		saveImage("../assets/asteroid/asteroid.png",resized);   					// saving image 
		//Resizing small asteroids 
		img = loadImage("assets/asteroid/small_asteroid.png"); 		   		// Loading Image 
		resized= Scalr.resize(img,Scalr.Method.QUALITY,            	// resizing image
			Scalr.Mode.AUTOMATIC,(int)(res_height/5) ,(int) (res_height/5));					// asteroids will be 1/5th of the screen height 
		saveImage("../assets/asteroid/small_asteroid.png",resized);   					// saving image 
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
		resizeMainBackground(res_width,res_height);
		credits(res_width,res_height);
		resizeSpaceship(res_width,res_height);
		resizeAsteroid(res_width,res_height);
		resizePlanet(res_width,res_height);
	}
}