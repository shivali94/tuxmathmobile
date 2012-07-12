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
	private var text_format:TextFormat;
	public function new (path:String,initialize_text:String)
	{
		super();
		asteroidBitmap = new Bitmap(Assets.getBitmapData(path));
		addChild(asteroidBitmap);
		text = new TextField();
		text_format = new TextFormat('Arial', 90, 0xFFFFFF, true);
		//text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		//text.autoSize = TextFieldAutoSize.CENTER;
		addChild(text);
		active = false;										// Inactive by default
		
		//Setting size
		text.text = initialize_text;
		var textSize:Float = asteroidBitmap.width * 0.7;
		if (text.textWidth > textSize)
			while (text.textWidth > textSize)
			{
				text_format.size-=2;
				text.setTextFormat(text_format);
			}
		else
			while (text.textWidth < textSize)
			{
				text_format.size+=2;
				text.setTextFormat(text_format);
			}
	}
	public function initializeText(displayText:String)
	{
		text.text = displayText;
		text.setTextFormat(text_format);
		text.y = (asteroidBitmap.height - text.textHeight) / 2;
		text.x = (asteroidBitmap.width - text.textWidth) / 2;
		text.width = text.textWidth * 1.1;
		text.height = text.textHeight;
	}
}

// Used for displaying small asteroids 
private class SmallAsteroid extends Asteroid
{
	public function new()
	{
		super("assets/asteroid/small_asteroid.png","888");
	}
}

class AsteroidContainer  extends Sprite 
{
	var asteroids:Array<Asteroid>;
	var small_asteroids:Array<SmallAsteroid>;
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
		stageWidth = GameConstant.stageWidth;
		//Loading asteroid destruction sound
		asteroid_destruction = Assets.getSound("assets/sounds/AsteroidExplosion.wav");
		//Initializing delta movement 
		deltaMovement = 0.02;
		adjustDeltaMovement = (GameConstant.stageWidth * 2 / 3) / 320 * deltaMovement;
		asteroids = new Array<Asteroid>();
		small_asteroids = new Array<SmallAsteroid>();
		 // Adding three asteroids 
		for (i in 0...3)
		{
			var temp = new Asteroid("assets/asteroid/asteroid.png","00+00=00");
			asteroids.push(temp);
		}
		 // Adding 6 small asteroids 
		for (i in 0...6)
		{
			var temp = new SmallAsteroid();
			small_asteroids.push(temp);
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
			asteroid.y = (GameConstant.stageHeight-asteroid.height)/2;
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
	
	//Function for adding factroid Asteroids 
	public function addFactroidAsteroid(param:Question)
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == true)
				continue;
			asteroid.x = stageWidth + 10;                                 // Start scrolling asteroid from the right side of the screen 
			asteroid.y = (GameConstant.stageHeight-asteroid.height)/2;
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
	
	public function addSmallAsteroids(param:Asteroid)
	{
		//Adding first asteroid
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == true)
				continue;
			small_asteroid.x =  param.x;                                 
			small_asteroid.y = param.y - param.width * 0.3;
			small_asteroid.answer = level.laserValue;  
			small_asteroid.initializeText(small_asteroid.answer + "");
			addChild(small_asteroid);
			small_asteroid.active = true;
			break;
		}
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == true)
				continue;
			small_asteroid.x =  param.x;                              
			small_asteroid.y = param.y + param.width * 0.3;
			small_asteroid.answer = cast param.answer / level.laserValue;  
			small_asteroid.initializeText(small_asteroid.answer + "");
			addChild(small_asteroid);
			small_asteroid.active = true;
			break;
		}
	}
	
	public function attackAsteroid()
	{
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == false)
				continue;
			if (small_asteroid.answer == level.laserValue)
			{
				level.spaceship.show_laser(small_asteroid.x + small_asteroid.height / 2 , small_asteroid.y + small_asteroid.width / 2);
				removeChild(small_asteroid);
				small_asteroid.active = false;
				asteroid_destruction.play();
				return { result:true, score:0.25 };
			}
		}
		// Attacking main asteroid 
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			if (asteroid.isFactroid == false)								// Not a factor asteroid
			{
				if (asteroid.answer == level.laserValue)
				{
					level.spaceship.show_laser(asteroid.x + asteroid.height / 2 , asteroid.y + asteroid.width / 2);
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
					if (level.laserValue == 1 || asteroid.answer == level.laserValue)                         
						return { result:false, score:0.0 };				// Because 1 is factor of every number and a number is a factor of itself
					else
					{
						if (asteroid.answer % level.laserValue == 0)
						{
							level.spaceship.show_laser(asteroid.x + asteroid.height / 2 , asteroid.y + asteroid.width / 2);
							removeChild(asteroid);
							asteroid.active = false;
							asteroid_destruction.play();
							addSmallAsteroids(asteroid);                        // Adding small asteroids 
							var score = asteroid.x / stageWidth / 0.75/2;		// Half score only because two more small asteroids will add having 0.25 value each	
							if (score > 0.5)									// Maximum score is 0.5. Total score for speed will be calculate by 
								score = 0.5;									// total_sum/total_no_of_question 
							return {result:true,score:score};
						}
					}
				}
		}
		return {result:false,score:0.0};           //Nothing found return 
	}
	
	public function handleAsteroid()						// This function will be responsible for updating  asteroid and autodestruction
	{
		// For big main asteroids 
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
		
		// For small asteroids 
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == false)
				continue;
			small_asteroid.x -= level.diffTime * asteroidSpeed;
			if (small_asteroid.x < asteroidLimit)
			{
				small_asteroid.active = false;
				removeChild(small_asteroid);
				asteroid_destruction.play();
			}
		}
	}
	
	// It is used to refresh everything and stop everything  
	public function stop()
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			asteroid.active = false;
			removeChild(asteroid);
		}
		// For small asteroids 
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == false)
				continue;
			small_asteroid.active = false;
			removeChild(small_asteroid);
		}
	}
	
}