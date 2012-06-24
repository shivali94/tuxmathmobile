package ;

/**
 * ...
 * @author Deepak Aggarwal
 */

import nme.net.SharedObject;
import nme.net.SharedObjectFlushStatus;

// Used for saving and Loading data 
class SavedData 
{
	public static var score_loader:SharedObject;
	public static var score:Array<Array<Int>>;				// Used for holding score. It's a 2d array
	public static function initialize() 
	{
		score_loader = SharedObject.getLocal("game-score");
		score = score_loader.data.score;
		if (score == null)       // No data is present before so initialize everything and store it 
		{
			// Initializing array and storing it
			var temp:Array<Int> = new Array<Int>();
			var temp_score:Array<Array<Int>> = new Array<Array<Int>>();
			for (x in 0...10)
				temp.push(0);
			for (x in 0...10)
				temp_score.push(temp);
			score = temp_score;
			save();
		}
	}
	
	public static function storeData(level:Int, sublevel:Int , score_value:Int)
	{
		score[level][sublevel] = score_value;
		save();
	}
	
	public static function save()
	{
		score_loader.data.score = score;            // saving into shared object so that is can be flushed 
		// Prepare to save.. with some checks
		#if ( cpp || neko )
				// Android didn't wanted SharedObjectFlushStatus not to be a String
				var flushStatus:SharedObjectFlushStatus = null;
		#else
				// Flash wanted it very much to be a String
				var flushStatus:String = null;
		#end

		try {
				flushStatus = score_loader.flush() ;      // Save the object
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