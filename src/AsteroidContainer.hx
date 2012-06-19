package ;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.Lib;
import nme.media.Sound;
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
		//text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		//text.autoSize = TextFieldAutoSize.CENTER;
		addChild(text);
		active = false;										// Inactive by default
		
		//Setting size
		text.text = "00+00=00";
		var textSize:Float = asteroidBitmap.width * 0.7;
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
	}
	public function initializeText(displayText:String)
	{
		text.text = displayText;
		text.setTextFormat(text_format);
		text.y = (asteroidBitmap.height - text.textHeight) / 2;
		text.x = (asteroidBitmap.width - text.textWidth) / 2;
	}
}

class AsteroidContainer  extends Sprite 
{
	var asteroids:Array<Asteroid>;
	var deltaMovement:Float;
	// adjustment factor for deltaMovement to that asteroid should cover same distance irrespective of screen resolution 
	// taking 480X320 as reference (2/3)*480= 320.Maximum time is 15 sec - Time for srolling across the screen.
	var adjustDeltaMovement:Float;               
	var level:Level; 
	var asteroidSpeed:Float;
	var asteroid_destruction:Sound;
	public function new(level_instance:Level) 
	{
		super();
		this.level = level_instance;
		//Loading asteroid destruction sound
		asteroid_destruction = Assets.getSound("assets/sounds/AsteroidExplosion.wav");
		//Initializing delta movement 
		deltaMovement = 0.02;
		adjustDeltaMovement = (Lib.current.stage.stageWidth * 2 / 3) / 320 * deltaMovement;
		asteroids = new Array<Asteroid>();
		 // Adding three asteroids 
		for (i in 0...3)
		{
			var temp = new Asteroid();
			asteroids.push(temp);
		}
	}
	
	// This function will be used to set speed of asteroid based on game level.
	public function setAsteroidSpeed(speed:Float)
	{
		asteroidSpeed = adjustDeltaMovement * speed; //Adjusting speed of asteroid according to level. Don't manipulate adjustDeltaMovement
	}
	
	// Function for adding asteroids
	public function addAsteroid(param:Question)
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == true)
				continue;
			asteroid.x = Lib.current.stage.stageWidth + 10;                                 // Start scrolling asteroid from the right side of the screen 
			asteroid.y = 130;
			if (param.missing == false)
			{
				switch(param.operation)
				{
					case sum:				asteroid.answer = param.operand1 + param.operand2;
											asteroid.initializeText(param.operand1 + "+" + param.operand2);
					case multiplication :	asteroid.answer = param.operand1 * param.operand2;
											asteroid.initializeText(param.operand1 + "X" + param.operand2);
					case division:			asteroid.answer = cast param.operand1 / param.operand2;
											asteroid.initializeText(param.operand1 + "÷" + param.operand2);
					case subtraction :		asteroid.answer = param.operand1 - param.operand2;
											asteroid.initializeText(param.operand1 + "-" + param.operand2);
				}
			}
			else									// If missing is true 
			{
				asteroid.answer = param.operand2;    // Same for all case 
				switch(param.operation)
				{
					case sum:	
											asteroid.initializeText(param.operand1 + "+ ? = " + (param.operand1 + param.operand2));
					case multiplication :	
											asteroid.initializeText(param.operand1 + "X ? = " + (param.operand1 * param.operand2));
					case division:			
											asteroid.initializeText(param.operand1 + "÷ ? = " + cast(Int)(param.operand1 / param.operand2));
					case subtraction :		
											asteroid.initializeText(param.operand1 + "- ? = " + (param.operand1 - param.operand2));
				}
			}
			addChild(asteroid);
			asteroid.active = true;
			break;
		}
	}
	
	public function attackAsteroid():Bool
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			if (asteroid.answer == level.laserValue)
			{
				removeChild(asteroid);
				asteroid.active = false;
				asteroid_destruction.play();
				return true;
			}
		}
		return false;
	}
	
	static var asteroidLimit:Int = cast Lib.current.stage.stageWidth / 3; 
	public function handleAsteroid()						// This function will be responsible for updating  asteroid and autodestruction
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			asteroid.x -= level.diffTime * asteroidSpeed;
			if (asteroid.x < asteroidLimit)
			{
				asteroid.active = false;
				removeChild(asteroid);
				asteroid_destruction.play();
			}
		}
	}
	
}