package tuxkids;
import haxe.Timer;
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
import nme.feedback.Haptic;
import com.eclecticdesignstudio.motion.Actuate;

/**
 * ...
 * @author Deepak Aggarwal
 */

 class AsteroidConstant
 {
	public static var dimension:Float;													// Dimension of each side of the cell of matrix.
	public static var matrix_dimesion:Int;                                              // Dimension of square matrix in which it will be broken.
	public static var updateListCenter:Array<Float>;									// Used for updating asteroid pieces when exploded from the center.
	public static var updateListFront:Array<Float>;										// Used for updating asteroid pieces when exploded from the front.
	public static var total_values ;													// Total in no frames in a explosion bitmap (total_values X total_values)  in one even or odd bitmap of frame.
	public static var FRONT_EXPLOSION:Int;												// Asteroid will explode from the front when it collide with the spaceship.
	public static var CENTER_EXPLOSION:Int;												// Asteroid will explode from the center.
	public static var tile_even:Tilesheet;												// Tilesheet for displaying even frame of explosion effect 
	public static var tile_odd:Tilesheet;												// Tilesheet for displaying odd frame of explosion effect
	public static var tile_position:Float;												// Position of the tile that is to be blit (x,y) for showing explosion effect 
	public static function initialize()
	{
		
		matrix_dimesion = 20 + cast (GameConstant.stageWidth*20/2048);                                       					// Asteroid will be divided into 20X20 matrix and more depending upon screen resolution.
		var temp:BitmapData = Assets.getBitmapData("assets/asteroid/asteroid0.png");	// Loading asteroid image so that we can pre calculate all variables 
		dimension = temp.width / matrix_dimesion;										// Dimension of individual cell side
		updateListCenter = new Array<Float>();											// Initialing arrays
		updateListFront = new Array<Float>();
		FRONT_EXPLOSION = 0;															// Used for indicate whether to explode from the center or front
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
				distance = cast Math.sqrt(vx * vx + vy * vy);							//Calculating distance from the center
				index = (y * matrix_dimesion + x) * total_values;
				// Taking 480 X 320 resolution as reference
				updateListCenter[index] = (Math.random() + 0.1) * vx / distance * GameConstant.stageWidth / 480;
				updateListCenter[index + 1] = (Math.random() + 0.1) * vy / distance * GameConstant.stageHeight / 320;
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
				// Taking 480 X 320 as reference
				updateListFront[index] = (Math.random() - 0.3) * (temp.width - vx) / distance * GameConstant.stageWidth / 480;
				updateListFront[index + 1] = (Math.random() - 0.1) * vy / distance * GameConstant.stageHeight / 320;
				updateListFront[index + 2] = 0;								// Do not change this value
				updateListFront[index + 3] = Math.random() * 0.04;
			}
			
		// Loading bitmap sprites into tilesheet 
		tile_even = new Tilesheet(Assets.getBitmapData("assets/explosion/even_frame.png"));
		tile_odd = new Tilesheet(Assets.getBitmapData("assets/explosion/odd_frame.png"));
		// Dimension of each frame
		var dimension = tile_even.nmeBitmap.width / 4;						
		// Initializing frames 
		for (y in 0...4)
			for (x in 0...4) {
				var rect = new Rectangle(x * dimension, y * dimension, dimension, dimension);
				tile_even.addTileRect(rect);
				tile_odd.addTileRect(rect);
			}
		// Calculating tile position to be drawn
		tile_position = (temp.width - tile_even.nmeBitmap.width / 2) / 2; 
	}
 }
 /**
  * Class used for loading and initializing asteroids with their corresponding Image 
  */
class Asteroid extends Sprite {
	/** Holds Image of asteroid  */
	public var asteroidBitmap:Bitmap; 
	/** Used for adding questions in text form inside asteroid */
	public var text:TextField;
	/** For text formating */
	private var text_format:TextFormat;
	/** Points whether asteroid contains a question and active ( Currently visible as a question on screen ) */
	public var active:Bool;									// Indicate whether asteroid is active or not 
	/** Stores correct answer of asteroid question */
	public var answer:Int;
	/** Whether asteroid is a factroid asteroid ( Contains a factroid question ) or not */ 
	public var isFactroid:Bool;                              
	/** Used for showing exploding asteroid*/
	var tiles:Tilesheet;
	var drawList:Array<Float>;
	var updateList:Array<Float>;
	/**Whether exploding or not. Used so that asteroid does not re-exploded when it crosses x limit while exploding */ 
	public var exploding:Bool;		
	/** Which frame of explosion is shown currently. */ 
	private var explosion_frame:Int;								
	private var even_explosion_frame:Bool;							// Even frame if true else off frame
	/**
	 * Constructor
	 * <br>
	 * @param	path   :- Path of image to be loaded   <br>
	 * @param	initialize_text   :- Initial text to be intialized for asteroid
	 */
	public function new (path:String,initialize_text:String)
	{
		super();
		tiles = new Tilesheet(Assets.getBitmapData(path));					// Initializing tilesheet object 
		asteroidBitmap = new Bitmap(tiles.nmeBitmap);						// Loading bitmap image using tilesheet object
		drawList = new Array<Float>();										// Initializing drawlist
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
		initialState();                                                   		// Initializing asteroid into it's initial state.
	}
	
	/**
	 * Used for initializing text which is being displayed within the asteroid. <br>
	 * @param	displayText  : Text which is to be displayed.
	 */
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
	/**
	 *  Restore or initialize asteroid into it's initial state
	 */
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
		// Initializing explosion frames variables for animations.
		explosion_frame = 0;						// Starting from frame zero.
		even_explosion_frame = true;
	}
	/**
	 * Used to show exploding effect when asteroid explodes on correct answer. <br>
	 * @param	type    :-   AsteroidConstant.CENTER_EXPLOSION or AsteroidConstant.FRONT_EXPLOSION
	 */
	public function explode(type:Int)
	{
		exploding = true;														// Asteroid is exploding
		removeChild(asteroidBitmap);											// Removing bitmap so that animation is visible
		removeChild(text);														// Reving text
		switch(type)
		{
			case AsteroidConstant.CENTER_EXPLOSION : updateList = AsteroidConstant.updateListCenter;
													 #if !flash
														Haptic.vibrate(0, 250);
													 #end 
			case AsteroidConstant.FRONT_EXPLOSION  : updateList = AsteroidConstant.updateListFront;
													 #if !flash
														Haptic.vibrate(0, 1800);
													 #end 
		}
		addEventListener(Event.ENTER_FRAME, update);
		Actuate.tween(this, 1.8,{}).onComplete(function(){
			Actuate.tween(this, 0.5, { alpha:0 } ).onComplete(function(){
				removeEventListener(Event.ENTER_FRAME, update);
				dispatchEvent(new Event("Asteroid Destroyed"));
				initialState();												// Restoring asteroid initial state
			});
		});
	}
	
	var length:Int;															// used by update function 
	/**
	 * Used for animating asteroid explosion 
	 * @param	ev
	 */
	private function update(ev:Event)
	{
		length = drawList.length;
		graphics.clear();													// Clearing sprite
		// Showing explosion effect
		if (explosion_frame <= 15 )
		{
			if(even_explosion_frame == true){
				AsteroidConstant.tile_even.drawTiles(graphics, [AsteroidConstant.tile_position, AsteroidConstant.tile_position, explosion_frame,2],false, Tilesheet.TILE_SCALE);
				even_explosion_frame = false;
			}
			else {
				AsteroidConstant.tile_odd.drawTiles(graphics, [AsteroidConstant.tile_position, AsteroidConstant.tile_position, explosion_frame,2],false, Tilesheet.TILE_SCALE);
				even_explosion_frame = true;
				explosion_frame++;
			}
		}
		// Exploding asteroids 
		for (x in 0...length)
		{
			drawList[x] += updateList[x];										// Updating asteroids broken pieces. 
		}
		tiles.drawTiles(graphics, drawList,false,Tilesheet.TILE_ROTATION);		// Blitting asteroid pieces.
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
/**
 * Class responsible for generating asteroids , moving and destroying them. It is also responsible for calculating score. 
 */
class AsteroidContainer  extends Sprite 
{
	var asteroids:Array<Asteroid>;																	// For holding big asteroids.
	var small_asteroids:Array<SmallAsteroid>;														// For holding small asteroids.
	var deltaMovement:Float;
	// adjustment factor for deltaMovement to that asteroid should cover same distance irrespective of screen resolution 
	// taking 480X320 as reference (2/3)*480= 320.Maximum time is 15 sec - Time for srolling across the screen.
	var adjustDeltaMovement:Float;               													// Adjusted delta Movement.
	var level:Level; 																				// For holding instance of level class which is used to access laser value so that asteroids can be destroyed based on it.
	var asteroidSpeed:Float;																		// Speed with which asteroids will move.
	var asteroid_destruction:Sound;																	// Sound that will be played when asteroid destroyed.
	var asteroidLimit:Float; 																		// limit in x co-ordinate after which a astroid will destroyed as if it collides with the spaceship.
	var stageWidth:Int;
	var asteroid_pieces_sprite:Sprite;																// Sprite on which pieces of asteroids will blit. 
	var asteroid_pieces_tile:Tilesheet;																// Tile for blitting asteroids pieces.
	var asteroid_piece_dimension:Float;																// Dimension of a each asteroid piece in combined sprite.
	var drawList:Array<Float>;																		// Array for drawing asteroid pieces which is used by asteroid_pieces_tile.
	
	// For showing warning 
	var showing_warning:Bool;
	var warning_overlay:Bitmap;
	var warning_sound:Sound;
	
	/**
	 * Constructor  <br>
	 * @param	level_instance  :- Instance of level class which is used to access laservalue 
	 */
	public function new(level_instance:Level) 
	{
		super();
		this.level = level_instance;
		AsteroidConstant.initialize();																// Initializing asteroids parameters.
		stageWidth = GameConstant.stageWidth;
		//Loading asteroid destruction sound
		asteroid_destruction = Assets.getSound("assets/sounds/AsteroidExplosion.wav");				// Loading asteroid explosion sound.
		deltaMovement = 0.02;																		// Initializing delta movement.
		adjustDeltaMovement = (GameConstant.stageWidth * 2 / 3) / 320 * deltaMovement;				// Adjusting delta movement based on screen resolution.
		asteroids = new Array<Asteroid>();
		small_asteroids = new Array<SmallAsteroid>();
		 // Adding three asteroids 
		for (i in 0...3)
		{
			var temp = new Asteroid("assets/asteroid/asteroid"+i+".png","00+00=00");
			asteroids.push(temp);
		}
		 // Adding 6 small asteroids 
		for (i in 0...6)
		{
			var temp = new SmallAsteroid();
			small_asteroids.push(temp);
		}
		
		// Adding asteroid_pieces_sprite
		asteroid_pieces_sprite  = new Sprite();
		addChild(asteroid_pieces_sprite);
		// Initializing asteroid_pieces_tile for blitting 
		asteroid_pieces_tile = new Tilesheet(Assets.getBitmapData("assets/asteroid/asteroid_pieces.png"));
		asteroid_piece_dimension = asteroid_pieces_tile.nmeBitmap.width / 4;
		for (y in 0...4)
			for (x in 0...4)
				asteroid_pieces_tile.addTileRect(new Rectangle(x * asteroid_piece_dimension, y * asteroid_piece_dimension,
						asteroid_piece_dimension, asteroid_piece_dimension));
		drawList = new Array<Float>();
		// Initializing asteroid pieces position 
		var index:Int;
		for (i in 0...16)
		{
			index = i * 4;
			drawList[index] = Math.random() * GameConstant.stageWidth;
			drawList[index+1] = Math.random() * GameConstant.stageHeight;
			drawList[index + 2] = i;
			drawList[index + 3] = Math.random() - 0.6;
		}
		
		// Initializing warning variables 
		showing_warning = false;
		warning_overlay = new Bitmap(Assets.getBitmapData("assets/overlay/overlay_red.png"));
		warning_overlay.alpha = 0;
		addChild(warning_overlay);
		warning_sound = Assets.getSound("assets/sounds/warning.mp3");
	}
	
	/**
	 * Function used to set speed of asteroid based on game level.  </br>
	 * @param	speed :- Speed to be set.
	 */
	public function setAsteroidSpeed(speed:Float)
	{
		asteroidLimit = level.spaceship.x + level.spaceship.width;   					//TODO FIXME I have to change it's position as it is showing a wierd behaviour when we update small asteroids. 
		asteroidSpeed = adjustDeltaMovement * speed; 									//Adjusting speed of asteroid according to level. Don't manipulate adjustDeltaMovement.
	}
	
	/**
	 * Function for adding non factroid asteroids. <br>
	 * @param	param :- Question to be initializied in it.
	 */
	private function addNonFactroidAsteroid(param:Question)
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == true)
				continue;
			asteroid.x = stageWidth + 10;                                 // Start scrolling asteroid from the right side of the screen 
			asteroid.y = (GameConstant.stageHeight - asteroid.height) / 2;
			// For general types of question
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
			// For missing types of question 
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
			addChild(asteroid);													// Adding asteroid.
			asteroid.active = true;												// Changing it's state to active.
			asteroid.isFactroid = false;         								// Not a factor asteroid 
			break;
		}
	}
	
	/**
	 * Function for adding factroid Asteroids. <br> 
	 * @param	param : Question to be initialized.
	 */
	private function addFactroidAsteroid(param:Question)
	{
		for (asteroid in asteroids)
		{
			if (asteroid.active == true)
				continue;
			asteroid.x = stageWidth + 10;                            			     // Start scrolling asteroid from the right side of the screen.
			asteroid.y = (GameConstant.stageHeight-asteroid.height)/2;
			asteroid.answer = param.operand1 * param.operand2;            			// It is used to check factor instead of just matching it.
			asteroid.initializeText(""+(param.operand1 * param.operand2));			// Initializing text inside asteroid.	
			addChild(asteroid);														// Adding asteroid.
			asteroid.active = true;													// Changing it's state to active.
			asteroid.isFactroid = true;            									// A factor asteroid.
			break;
		}
	}
	
	/**
	 * Function for adding asteroids. <br>
	 * @param	param  :- Question to be initialized.
	 */
	public function addAsteroid(param:Question)
	{
		if (param.factroid == false)
			addNonFactroidAsteroid(param);
		if (param.factroid == true)
			addFactroidAsteroid(param);
	}
	/**
	 * Function for adding small asteroid when a big factroid asteroid explodes.<br>
	 * @param	param	:- 	Question to be initialized.<br>
	 * @param	position :- Position at which they are added.
	 */
	private function addSmallAsteroids(param:Asteroid,position:Float)
	{
		//Adding first asteroid
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == true)
				continue;
			// Initializing position.
			small_asteroid.x =  param.x;                                 
			small_asteroid.y = position - param.asteroidBitmap.height * 0.3;
			small_asteroid.answer = level.laserValue;  												// Initializing answer of asteroid.
			small_asteroid.initializeText(small_asteroid.answer + "");								// Text to be shown inside asteroid.
			addChild(small_asteroid);																// Adding it.
			small_asteroid.active = true;															// Switching state to active.
			break;
		}
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == true)
				continue;
			small_asteroid.x =  param.x;                              
			small_asteroid.y = position + param.asteroidBitmap.height * 0.3;
			small_asteroid.answer = cast param.answer / level.laserValue;  
			small_asteroid.initializeText(small_asteroid.answer + "");
			addChild(small_asteroid);
			small_asteroid.active = true;
			break;
		}
	}
	/**
	 * Function to check if asteroid is to be destroyed based on laser value accessed by instance of level.
	 */
	public function attackAsteroid()
	{
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == false)
				continue;
			// Checking laser value.
			if (small_asteroid.answer == level.laserValue)
			{
				// Showing laser. 
				level.spaceship.show_laser(small_asteroid.x + small_asteroid.height / 2 , small_asteroid.y + small_asteroid.width / 2);
				removeChild(small_asteroid);												// Removing asteroid small one.
				small_asteroid.active = false;												// Turning state to inactive.
				asteroid_destruction.play();												// Playing destruction sound. 
				return { result:true, score:0.25 };											// returning result.
			}
		}
		// Attacking main asteroid 
		for (asteroid in asteroids)
		{
			if (asteroid.active == false || asteroid.exploding == true)						// Make sure user do not answer inactive or exploding asteroid.
				continue;
			if (asteroid.isFactroid == false)												// Not a factor asteroid.
			{
				if (asteroid.answer == level.laserValue)
				{
					level.spaceship.show_laser(asteroid.x + asteroid.height / 2 , asteroid.y + asteroid.width / 2);
					asteroid_destruction.play();
					var score = asteroid.x / stageWidth / 0.75;								// Player will get full score in speed if he answer question.
																							// within 25% of the total time.
					if (score > 1.0)														// Maximum score is one. Total score for speed will be calculate by 
						score = 1.0;														// total_sum/total_no_of_question. 
					asteroid.explode(AsteroidConstant.CENTER_EXPLOSION);					// Exploding asteroid from the center.
					function eventHandler(ev:Event){
						removeChild(asteroid);
						asteroid.removeEventListener("Asteroid Destroyed",eventHandler);
					}
					asteroid.addEventListener("Asteroid Destroyed",eventHandler);			// To be fired when asteroid destroying animation completes.
					return {result:true,score:score};										// Returning score.
				}
			}
			else                                                    					     // Attack factor asteroid. 
				{
					if (level.laserValue == 1 || asteroid.answer == level.laserValue)                         
						return { result:false, score:0.0 };									// Because 1 is factor of every number and a number is a factor of itself.
					else
					{
						if (asteroid.answer % level.laserValue == 0)
						{
							level.spaceship.show_laser(asteroid.x + asteroid.height / 2 , asteroid.y + asteroid.width / 2);
							asteroid_destruction.play();
							asteroid.explode(AsteroidConstant.CENTER_EXPLOSION);
							function eventHandler(ev:Event){
								removeChild(asteroid);
								asteroid.removeEventListener("Asteroid Destroyed",eventHandler);
							}
							asteroid.addEventListener("Asteroid Destroyed",eventHandler);
							addSmallAsteroids(asteroid,asteroid.y);                        	// Adding small asteroids. 
							var score = asteroid.x / stageWidth / 0.75/2;					// Half score only because two more small asteroids will add which having 0.25 value each.
							if (score > 0.5)												// Maximum score is 0.5. Total score for speed will be calculate by 
								score = 0.5;												// total_sum/total_no_of_question.
							return {result:true,score:score};
						}
					}
				}
		}
		return {result:false,score:0.0};          											 //Nothing found return. 
	}
	
	/**
	 * Function for showing warning.
	 */
	function show_warning()
	{
		if (showing_warning == true)
			return;
		showing_warning = true;
		warning_sound.play();
		Actuate.tween(warning_overlay, 0.5, { alpha:1 } )
		.onComplete(function() {
			Actuate.tween(warning_overlay, 0.7, { alpha:0 } )
			.onComplete(function() {
				showing_warning = false;
			});
		});
	}
	
	var index:Int;
	var asteroid_pieces_delta:Float;														// Used for updating asteroid pieces.
	/**
	 * Function responsible for updating  asteroid and autodestruction them.
	 */
	public function handleAsteroid()						
	{
		// For big main asteroids.
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			asteroid.x -= level.diffTime * asteroidSpeed;									// Updating asteroid position.
			if(!asteroid.exploding)															// Make sure we don't explode asteroid that are already exploding. 
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
				else
				if (asteroid.x < (GameConstant.stageWidth/1.7 ))
				{
					if (showing_warning == false)
						show_warning();
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
		
		// Animating asteroid pieces. 
		asteroid_pieces_sprite.graphics.clear();									// Clearing sprite.
		asteroid_pieces_delta = 0.03 * level.diffTime;    							// Time based animation.
		// Updating there position.
		for (i in 0...16)
		{
			asteroid_pieces_delta *= 0.95;
			index = i * 4;
			drawList[index] -= asteroid_pieces_delta;
			//drawList[i + 1] = ;                     No need to do it 
			drawList[index + 2] = i;
			// drawList[i + 3] ;                      Do not change it 
			if (drawList[index]< -asteroid_piece_dimension)
			{
				drawList[index] = GameConstant.stageWidth;
				drawList[index + 1] = Math.random() * GameConstant.stageHeight;
				drawList[index + 2] = i;
				drawList[index + 3] = Math.random() - 0.6;
			}
		}
		// Blitting asteroid pieces.
		asteroid_pieces_tile.drawTiles(asteroid_pieces_sprite.graphics, drawList, false, Tilesheet.TILE_ROTATION);
	}
	 
	/**
	 * It is used to refresh and stop everything.
	 */
	public function stop()
	{
		// Stoping all asteroids.
		for (asteroid in asteroids)
		{
			if (asteroid.active == false)
				continue;
			asteroid.active = false;
			removeChild(asteroid);
		}
		// Stoping small asteroids.
		for (small_asteroid in small_asteroids)
		{
			if (small_asteroid.active == false)
				continue;
			small_asteroid.active = false;
			removeChild(small_asteroid);
		}
	}
	
}