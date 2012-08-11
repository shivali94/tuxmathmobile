package tuxkids;

/**
 * ...
 * @author Deepak Aggarwal
 */

import nme.net.SharedObject;
import nme.net.SharedObjectFlushStatus;

/**
 * Used for saving and loading data.
 */
class SavedData 
{
	// I have tried to use 2D array but it is buggy
	private static var score_loader:Array<SharedObject>;
	/**
	 * Used for holding score. It's a 2D array.
	 */
	public static var score:Array<Array<Int>>;	
	/**
	 * Function for loading score.
	 */
	public static function initialize() 
	{
		score_loader = new Array<SharedObject>();
		score = new Array<Array<Int>>();
		for (x in 0...9)
		{
			// for level x score data is stored in game-score-level-x kust replace x with corresponding number
			score_loader.push(SharedObject.getLocal("game-score-level-"+x));
			score.push(score_loader[x].data.score);
		}
		if (score[0] == null)       // No data is present before so initialize everything and store it we are checking first element only
		{
			// Initializing array and storing it
			var temp:Array<Int> = new Array<Int>();
			var temp_score:Array<Array<Int>> = new Array<Array<Int>>();
			for (x in 0...10)
				temp.push(0);
			for (x in 0...9)
				temp_score.push(temp);
			score = temp_score;
			save();
		}
	}
	
	/**
	 * Function for saving data.   <br>
	 * @param	level         
	 * @param	sublevel
	 * @param	score_value
	 */
	public static function storeData(level:Int, sublevel:Int , score_value:Int)
	{
		score[level][sublevel] = score_value;
		save();
	}
	
	/**
	 * Function used to store data on physical device 
	 */
	private static function save()
	{
		for(x in 0...9)
			score_loader[x].data.score = score[x];            // saving into shared object so that is can be flushed 
		// Prepare to save.. with some checks
		#if ( cpp || neko )
				// Android didn't wanted SharedObjectFlushStatus not to be a String
				var flushStatus:SharedObjectFlushStatus = null;
		#else
				// Flash wanted it very much to be a String
				var flushStatus:String = null;
		#end

		try {
			for(x in 0...9)
				flushStatus = score_loader[x].flush() ;      // Save the object
		} catch ( e:Dynamic ) {
				trace('couldn\'t write...');
		}

		if ( flushStatus != null ) {
			switch( flushStatus ) {
				case SharedObjectFlushStatus.PENDING:
						trace('requesting permission to save');
				case SharedObjectFlushStatus.FLUSHED:
						trace('value saved');
			}
		}
	
	}
}