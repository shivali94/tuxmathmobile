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
	public var isFactroid:Bool;                              // Whether asteroid is a factroid asteroid or not 
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
	var asteroidLimit:Int; 
	var stageWidth:Int;
	public function new(level_instance:Level) 
	{
		super();
		this.level = level_instance;
		stageWidth = Lib.current.stage.stageWidth;
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
		asteroidLimit = cast stageWidth / 3; 
	}
	
	// This function will be used to set speed of asteroid based on game level.
	public function setAsteroidSpeed(speed:Float)
	{
		asteroidSpeed = adjustDeltaMovement * speed; //Adjusting speed of asteroid according to level. Don't manipulate adjustDeltaMovement
	}
	
	// Function for adding non factroid asteroids
	private function addNonFactroidAsteroid(param:Question)
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == true)
				continue;
			asteroid.x = stageWidth + 10;                                 // Start scrolling asteroid from the right side of the screen 
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
											var temp:Int =  cast(param.operand1 / param.operand2);
											asteroid.initializeText(param.operand1 + "÷ ? = " +temp);
					case subtraction :		
											asteroid.initializeText(param.operand1 + "- ? = " + (param.operand1 - param.operand2));
				}
			}
			addChild(asteroid);
			asteroid.active = true;
			asteroid.isFactroid = false;         // Not a factor asteroid 
			break;
		}
	}
	
	public function addFactroidAsteroid(param:Question)
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == true)
				continue;
			asteroid.x = stageWidth + 10;                                 // Start scrolling asteroid from the right side of the screen 
			asteroid.y = 130;
			asteroid.answer = param.operand1 * param.operand2;            // It is used to check factor instead of just matching it.
			asteroid.initializeText(""+(param.operand1 * param.operand2));
			addChild(asteroid);
			asteroid.active = true;
			asteroid.isFactroid = true;            // A factor asteroid
			break;
		}
	}
	
	// Function for adding asteroids 
	public function addAsteroid(param:Question)
	{
		if (param.factroid == false)
			addNonFactroidAsteroid(param);
		if (param.factroid == true)
			addFactroidAsteroid(param);
	}
	
	public function attackAsteroid()
	{
		// Attacking main asteroid 
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			if (asteroid.isFactroid == false)
			{
				if (asteroid.answer == level.laserValue)
				{
					removeChild(asteroid);
					asteroid.active = false;
					asteroid_destruction.play();
					var score = asteroid.x / stageWidth / 0.75;			// Player will get full score in speed if he answer question 
																		// within 25% of the total time 
					if (score > 1.0)									// Maximum score is one. Total score for speed will be calculate by 
						score = 1.0;									// total_sum/total_no_of_question 
					return {result:true,score:score};
				}
			}
			else                                                         // Attack factor asteroid 
				{
					if (level.laserValue == 1)                         
						return { result:false, score:0.0 };				// Because 1 is factor of every number 
					else
					{
						if (asteroid.answer % level.laserValue == 0)
						{
							removeChild(asteroid);
							asteroid.active = false;
							asteroid_destruction.play();
							var score = asteroid.x / stageWidth / 0.75/2;		// Half score only because two more small asteroids will add having 0.25 value each	
							if (score > 0.5)									// Maximum score is 0.5. Total score for speed will be calculate by 
								score = 0.5;									// total_sum/total_no_of_question 
							return {result:true,score:score};
						}
					}
				}
		}
		return {result:false,score:0.0};
	}
	
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