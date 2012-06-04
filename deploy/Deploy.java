import java.awt.Image;
import java.awt.image.*;
import org.imgscalr.*;
import javax.imageio.*;
import java.io.File;

public class Deploy{
	
	static void resize(String target,String saveas,int width, int height)
	{
		BufferedImage img = null;
		try{
			img= ImageIO.read(new File(target));
		}
		catch(Exception ex){
			System.out.println("Unable to open file");
		}

		// resizing image
		BufferedImage resized= Scalr.resize(img,Scalr.Method.QUALITY,
			Scalr.Mode.AUTOMATIC,width,height);
		resized = Scalr.crop(resized,width,height);
		try{
			File outfile = new File(saveas);
			ImageIO.write(resized,"png",outfile);
		}
		catch( Exception ex){
			System.out.println("Unable to save resized Image");
		}
	} 
	public static void main( String args[])
	{
		int sub_level_time= 2;
		float delta_movement=0.02f;
		float width;
		if(args.length<2)
		{
			System.out.println("Please provide correct arguments");
			System.exit(0);
		}
		width= (sub_level_time*60*1000)*delta_movement +Integer.parseInt(args[0]);    
 		resize("assets/background/background_space.png","../assets/background/background_space.png",
			(int)width,Integer.parseInt(args[1]));
	}
}