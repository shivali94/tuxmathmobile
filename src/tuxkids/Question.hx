package tuxkids;

/**
 * ...
 * @author Deepak Aggarwal
 */

/**
 * Class that will be used to pass question to AsteroidContainer class.
 */
class Question 
{
	/**
	 * First operand
	 */
	public var operand1:Int; 
	/**
	 * Second operand
	 */
	public var operand2:Int;
	/**
	 * Whether a missing number question or not. 
	 */
	public var missing:Bool;
	/**
	 * Type of arithmetic operation.
	 */
	public var operation:ArithmeticOperation;
	/**
	 * Whether it's a factroid question.
	 */
	public var factroid :Bool;                     // Whether a question is factroid or not 
	/**
	 * Constructor
	 */
	public function new() 
	{ 
		missing = false;
	}
}