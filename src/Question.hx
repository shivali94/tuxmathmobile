package ;

/**
 * ...
 * @author Deepak Aggarwal
 */
// Class that will be used to pass question to AsteroidContainer class
class Question 
{
	public var operand1:Int; 
	public var operand2:Int;
	public var missing:Bool;
	public var operation:ArithmeticOperation;
	public var factroid :Bool;                     // Whether a question is factroid or not 
	public function new() 
	{ 
		missing = false;
	}
}