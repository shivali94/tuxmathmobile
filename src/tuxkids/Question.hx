
/*=======================================================================================================
												LICENSE 
  =======================================================================================================
  
				The contents of this file are subject to the Mozilla Public
				License Version 2.0 (the "License"); you may not use this file
				except in compliance with the License. You may obtain a copy of
				the License at http://www.mozilla.org/MPL/2.0/

				Software distributed under the License is distributed on an "AS
				IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
				implied. See the License for the specific language governing
				rights and limitations under the License.

				The Original Code is "Tuxmath"
				
				Copyright (C) 2012 by Tux4kids.  All Rights Reserved.
				Author : Deepak Aggarwal
  =======================================================================================================*/

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