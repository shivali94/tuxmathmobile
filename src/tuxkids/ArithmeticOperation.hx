
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
  * Used to indicate type of arithmetic operation 
  * </br>
  * 	1. It is used by GenerateQuestion class while generating question and </br>
  * 	2. AsteroidContainer class for initializing asteroids questions
  */
enum ArithmeticOperation 
{
	sum;
	subtraction;
	division;
	multiplication;
}