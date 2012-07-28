package ;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.Lib;
import nme.media.Sound;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.geom.Rectangle;
import com.eclecticdesignstudio.motion.Actuate;

/**
 * ...
 * @author Deepak Aggarwal
 */

 class AsteroidConstant
 {
	public static var dimension:Float;													// Dimension of each side of the cell of matrix
	public static var matrix_dimesion:Int;                                                  // Dimension of square matrix in which it will be broken
	public static var updateListCenter:Array<Float>;											// Used for updating asteroid pieces 
	public static var updateListFront:Array<Float>;
	public static var total_values ;
	public static var FRONT_EXPLOSION:Int;
	public static var CENTER_EXPLOSION:Int;
	public static function initialize()
	{
		matrix_dimesion = 25;                                       // It will ne divided into 25X25 matrix
		var temp:BitmapData = Assets.getBitmapData("assets/asteroid/asteroid.png");
		dimension = temp.width / matrix_dimesion;		// Dimension of individual cell side
		updateListCenter = new Array<Float>();
		updateListFront = new Array<Float>();
		FRONT_EXPLOSION = 0;
		CENTER_EXPLOSION = 1;
			// Calculating update list
		var center:Int = cast temp.width / 2;
		var vy:Int;
		var vx:Int;
		var index;
		var distance;
		total_values = 4;
		// Explosion from center
		for (y in 0...matrix_dimesion)
			for (x in 0...matrix_dimesion)
			{
				vx = cast (x * dimension - center);
				vy = cast (y * dimension - center);
				distance = cast Math.sqrt(vx * vx + vy * vy);
				index = (y * matrix_dimesion + x) * total_values;
				updateListCenter[index] = (Math.random() + 0.1) * vx / distance;
				updateListCenter[index + 1] = (Math.random() + 0.1) * vy / distance;
				updateListCenter[index + 2] = 0;								// Do not change this value
				updateListCenter[index + 3] = Math.random() * 0.04;
			}
		// Explosion from front	
		for (y in 0...matrix_dimesion)
			for (x in 0...matrix_dimesion)
			{
				vx = cast x * dimension;
				vy = cast y * dimension - center;
				distance = cast Math.sqrt(vx * vx + vy * vy);
				index = (y * matrix_dimesion + x) * total_values;
				updateListFront[index] = (Math.random() - 0.3) * (temp.width - vx) / distance;
				updateListFront[index + 1] = (Math.random() - 0.1) * vy / distance;
				updateListFront[index + 2] = 0;								// Do not change this value
				updateListFront[index + 3] = Math.random() * 0.04;
			}
	}
 }
class Asteroid extends Sprite {
	private var asteroidBitmap:Bitmap;
	public var text:TextField;
	public var active:Bool;									// Indicate whether asteroid is active or not 
	public var answer:Int;
	public var isFactroid:Bool;                              // Whether asteroid is a factroid asteroid or not 
	private var text_format:TextFormat;
	var drawList:Array<Float>;
	var tiles:Tilesheet;
	var updateList:Array<Float>;
	public var exploding:Bool;										// Whether exploding or not. Used so that it is not re-exploded when it crosses x limit while exploding  
	public function new (path:String,initialize_text:String)
	{
		super();
		tiles = new Tilesheet(Assets.getBitmapData(path));
		asteroidBitmap = new Bitmap(tiles.nmeBitmap);
		drawList = new Array<Float>();										// Initialize drawlist
		// Adding rectangles to tile 
		for (y in 0...AsteroidConstant.matrix_dimesion)
			for (x in 0...AsteroidConstant.matrix_dimesion)
			{
				tiles.addTileRect(new Rectangle(x * AsteroidConstant.dimension, y * AsteroidConstant.dimension,AsteroidConstant.dimension,AsteroidConstant.dimension));
			}
		text = new TextField();
		text_format = new TextFormat('Arial', 90, 0xFFFFFF, true);
		//text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		//text.autoSize = TextFieldAutoSize.CENTER;
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
		initialState();
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
	var index:Int;
	private function initialState()
	{
		graphics.clear();							// Making sure there is nothing on the sprite 
		addChild(asteroidBitmap);					// Adding bitmap	
		addChild(text);								// Adding text 
		active = false;								// Inactive by default
		exploding = false;
		// Initial state of cells of bitmap
		for (y in 0...AsteroidConstant.matrix_dimesion)
			for (x in 0...AsteroidConstant.matrix_dimesion)
			{
				index = (y * AsteroidConstant.matrix_dimesion + x) * AsteroidConstant.total_values;
				drawList[index] = x * AsteroidConstant.dimension;
				drawList[index + 1] = y * AsteroidConstant.dimension;
				drawList[index + 2] = index / AsteroidConstant.total_values;
				drawList[index + 3] = 0;
			}
		this.alpha = 1;								// fully visible
		this.visible = true;
	}
	public function explode(type:Int)
	{
		exploding = true;
		removeChild(asteroidBitmap);
		removeChild(text);
		switch(type)
		{
			case AsteroidConstant.CENTER_EXPLOSION : updateList = AsteroidConstant.updateListCenter;
			case AsteroidConstant.FRONT_EXPLOSION  : updateList = AsteroidConstant.updateListFront;
		}
		addEventListener(Event.ENTER_FRAME, update);
		Actuate.tween(this, 1.8,{}).onComplete(function(){
			Actuate.tween(this, 0.5, { alpha:0 } ).onComplete(function(){
				removeEventListener(Event.ENTER_FRAME, update);
				dispatchEvent(new Event("Asteroid Destroyed"));
				initialState();
			});
		});
	}
	public function update(ev:Event)
	{
		graphics.clear();
		for (x in 0...drawList.length)
		{
			drawList[x] += updateList[x];
		}
		tiles.drawTiles(graphics, drawList,false,Tilesheet.TILE_ROTATION);
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
	var asteroidLimit:Float; 
	var stageWidth:Int;
	public function new(level_instance:Level) 
	{
		super();
		this.level = level_instance;
		AsteroidConstant.initialize();
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
			if (asteroid.active == false || asteroid.exploding == true)				// Make sure user do not answer inactive or exploding asteroid
				continue;
			if (asteroid.isFactroid == false)								// Not a factor asteroid
			{
				if (asteroid.answer == level.laserValue)
				{
					level.spaceship.show_laser(asteroid.x + asteroid.height / 2 , asteroid.y + asteroid.width / 2);
					asteroid_destruction.play();
					var score = asteroid.x / stageWidth / 0.75;			// Player will get full score in speed if he answer question 
																		// within 25% of the total time 
					if (score > 1.0)									// Maximum score is one. Total score for speed will be calculate by 
						score = 1.0;									// total_sum/total_no_of_question 
					asteroid.explode(AsteroidConstant.CENTER_EXPLOSION);
					function eventHandler(ev:Event){
						removeChild(asteroid);
						asteroid.removeEventListener("Asteroid Destroyed",eventHandler);
					}
					asteroid.addEventListener("Asteroid Destroyed",eventHandler);
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
		asteroidLimit = level.spaceship.x + level.spaceship.width;
		// For big main asteroids 
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			asteroid.x -= level.diffTime * asteroidSpeed;
			if(!asteroid.exploding)								// Make sure we don't explode asteroid that are already exploding 
				if (asteroid.x < asteroidLimit)
				{
					asteroid_destruction.play();
					asteroid.explode(AsteroidConstant.FRONT_EXPLOSION);
						function eventHandler(ev:Event){
							removeChild(asteroid);
							asteroid.removeEventListener("Asteroid Destroyed",eventHandler);
						}
						asteroid.addEventListener("Asteroid Destroyed",eventHandler);
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