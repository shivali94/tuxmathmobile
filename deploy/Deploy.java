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
		if(args.length<2)
		{
			System.out.println("Please provide correct arguments");
			System.exit(0);
		}
		resize("assets/background/background_space.png","../assets/background/background_space.png",
			Integer.parseInt(args[0])*3,Integer.parseInt(args[1]));
	}
}