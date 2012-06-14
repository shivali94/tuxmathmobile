package ;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author Deepak Aggarwal
 */
class Asteroid extends Sprite {
	private var asteroidBitmap:Bitmap;
	public var text:TextField;
	public var active:Bool;									// Indicate whether asteroid is active or not 
	public var answer:Int;
	private static var text_format:TextFormat;
	public function new ()
	{
		super();
		asteroidBitmap = new Bitmap(Assets.getBitmapData("assets/asteroid/asteroid.png"));
		addChild(asteroidBitmap);
		text = new TextField();
		text_format = new TextFormat('Arial', 30, 0xFFFFFF, true);
		text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		text.autoSize = TextFieldAutoSize.CENTER;
		addChild(text);
		active = false;										// Inactive by default
	}
	public function initiaizeText(displayText:String)
	{
		text.text = displayText;
		var textSize:Float = asteroidBitmap.width * 0.5;
		if (text.textWidth > textSize)
			while (text.textWidth > textSize)
			{
				text_format.size--;
				text.setTextFormat(text_format);
			}
		else
			while (text.textWidth < textSize)
			{
				text_format.size++;
				text.setTextFormat(text_format);
			}
		text.y = (asteroidBitmap.height - text.textHeight) / 2;
		text.x = (asteroidBitmap.width - text.textWidth) / 2;
	}
}



class AsteroidContainer  extends Sprite 
{
	var asteroids:Array<Asteroid>;
	var deltaMovement:Float;
	// adjustment factor for deltaMovement to that asteroid should cover same distance irrespective of screen resolution 
	// taking 480X320 as reference (2/3)*480= 320.Maximum time is 16 sec 
	var adjustDeltaMovement:Float;               
	var level:Level; 
	var asteroidSpeed:Float;
	public function new(level_instance:Level) 
	{
		super();
		this.level = level_instance;
		//Initializing delta movement 
		deltaMovement = 0.02;
		adjustDeltaMovement = (Lib.current.stage.stageWidth * 2 / 3) / 320 * deltaMovement;
		asteroids = new Array<Asteroid>();
		for (i in 0...3)
		{
			var temp = new Asteroid();
			asteroids.push(temp);
		}
	}
	public function addAsteroid(val1:Int,val2:Int )
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == true)
				continue;
			asteroid.x = Lib.current.stage.stageWidth + 10;                                 // Start scrolling asteroid from the right side of the screen 
			asteroid.y = 130;
			asteroid.initiaizeText(val1 + "+" + val2);
			asteroid.answer = val1 + val2;
			addChild(asteroid);
			asteroidSpeed = deltaMovement * 1.1;
			asteroid.active = true;
			break;
		}
	}
	public function attackAsteroid()
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			if (asteroid.answer == level.laserValue)
			{
				removeChild(asteroid);
				asteroid.active = false;
				level.laserValue = 0;										// Reseting value to zero in case if answer in single digit
			}
		}
	}
	public function handleAsteroid()						// This function will be responsible for updating and destroying asteroid 
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			asteroid.x -= level.diffTime * adjustDeltaMovement;
		}
	}
	
}