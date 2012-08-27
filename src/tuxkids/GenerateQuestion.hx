
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
 *  This class will be used for generating question within the game. <br>
 *  1. First instance of this class is made. <br>
 *  2. Then setQuestions() is used to set questions according to Level and Sublevel. <br>
 *  3. newQuestion() function is used to generate new question.   <br>
 */

class GenerateQuestion 
{
	var operand_1_maxrange:Int;
	var operand_2_maxrange:Int;	
	var operand_1_minrange:Int;
	var operand_2_minrange:Int;
	var arith_operation:ArithmeticOperation;
	var multi_arith_operation_array:Array<ArithmeticOperation>;
	var question:Question;							// Used for storing question and returning it.
	var missing:Bool;								// Missing numbers ?
	var missing_random:Bool;						// Missing number with non missing questions
	var multiple_arith_operation:Bool;              // Whether multiple arithmetic operation is enabled or not 
	var factroid:Bool;								// Factroid question are enabled or not
	var factroid_random:Bool;						// Factroid question with non factroid question 
	var factroid_prime_number:Array<Int>;            // Used to store prime number for generating questions of factroid 
	var pro_mode:Bool;								// Whether player is playing last level( Most difficult)
	/**
	 * Constructor.
	 */
	public function new() 
	{
		question = new Question();
		multi_arith_operation_array = new Array<ArithmeticOperation>();
		factroid_prime_number = new Array<Int>();
	}
	
	/**
	 * Function used to set Level and sublevel. <br>
	 * @param	level  
	 * @param	sublevel
	 */
	public function setQuestions(level:Int , sublevel:Int)
	{
		multiple_arith_operation = false;   // Common to most of subcase of cases
		factroid = false ;
		pro_mode = false;
		switch(level)
		{
			case 1:  // Addition
				switch(sublevel)
					{
						case 1:	operand_1_maxrange = 2;				                //Sum upto 5							
								operand_2_maxrange = 3;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = false;
								missing_random = false;
						case 2: operand_1_maxrange = 6;								//Sum upto 10											
								operand_2_maxrange = 4;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = false;
								missing_random = false;
						case 3: operand_1_maxrange = 8;								//Sum upto 15											
								operand_2_maxrange = 7;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = false;
								missing_random = false;
						case 4: operand_1_maxrange = 11;							//Sum upto 20											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = false;
								missing_random = false;
						case 5: operand_1_maxrange = 31;							//Sum of 2 digit numbers 											
								operand_2_maxrange = 19;
								operand_1_minrange = 10;								
								operand_2_minrange = 10;
								arith_operation = ArithmeticOperation.sum;
								missing = false;
								missing_random = false;
						case 6:	operand_1_maxrange = 11;							//Missing number											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = true;
								missing_random = false;
						case 7:	operand_1_maxrange = 31;							//Missing number two digit number 											
								operand_2_maxrange = 19;
								operand_1_minrange = 10;								
								operand_2_minrange = 10;
								arith_operation = ArithmeticOperation.sum;
								missing = true;
								missing_random = false;
						case 8: operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = true;
								missing_random = true;
						case 9: operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = true;
								missing_random = true;
						case 10:operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								missing = true;
								missing_random = true;
					}
					
			case 2:               // Subtraction
				switch(sublevel)
					{
						case 1:	operand_1_maxrange = 2;				                //Subtraction upto 5							
								operand_2_maxrange = 3;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = false;
								missing_random = false;
						case 2: operand_1_maxrange = 10;								//Subtraction upto 10											
								operand_2_maxrange = 4;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = false;
								missing_random = false;
						case 3: operand_1_maxrange = 15;								//Subtraction upto 15											
								operand_2_maxrange = 7;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = false;
								missing_random = false;
						case 4: operand_1_maxrange = 20;							//Subtraction upto 20											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = false;
								missing_random = false;
						case 5: operand_1_maxrange = 31;							//Subtsractions of 2 digit numbers 											
								operand_2_maxrange = 19;
								operand_1_minrange = 10;								
								operand_2_minrange = 10;
								arith_operation = ArithmeticOperation.subtraction;
								missing = false;
								missing_random = false;
						case 6:	operand_1_maxrange = 11;							//Missing number											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = true;
								missing_random = false;
						case 7:	operand_1_maxrange = 31;							//Missing number two digit number 											
								operand_2_maxrange = 19;
								operand_1_minrange = 10;								
								operand_2_minrange = 10;
								arith_operation = ArithmeticOperation.subtraction;
								missing = true;
								missing_random = false;
						case 8: operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = true;
								missing_random = true;
						case 9: operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = true;
								missing_random = true;
						case 10:operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = true;
								missing_random = true;
					}
					
			case 3:   // Addition and subtraction operations 
				multiple_arith_operation = true;                                               // Turning multiple operation true
				multi_arith_operation_array.splice(0, multi_arith_operation_array.length - 1);    // Clearing array
				multi_arith_operation_array.push(ArithmeticOperation.subtraction);
				multi_arith_operation_array.push(ArithmeticOperation.sum);
				switch(sublevel)
					{
						case 1:	operand_1_maxrange = 2;				                //upto 5							
								operand_2_maxrange = 3;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = false;
								missing_random = false;
						case 2: operand_1_maxrange = 6;								// upto 10											
								operand_2_maxrange = 4;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = false;
								missing_random = false;
						case 3: operand_1_maxrange = 8;								// upto 15											
								operand_2_maxrange = 7;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = false;
								missing_random = false;
						case 4: operand_1_maxrange = 11;							//upto 20											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = false;
								missing_random = false;
						case 5: operand_1_maxrange = 31;							//2 digit numbers 											
								operand_2_maxrange = 19;
								operand_1_minrange = 10;								
								operand_2_minrange = 10;
								missing = false;
								missing_random = false;
						case 6:	operand_1_maxrange = 11;							//Missing number											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = true;
								missing_random = false;
						case 7:	operand_1_maxrange = 31;							//Missing two digit number 											
								operand_2_maxrange = 19;
								operand_1_minrange = 10;								
								operand_2_minrange = 10;
								missing = true;
								missing_random = false;
						case 8: operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = true;
								missing_random = true;
						case 9: operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = true;
								missing_random = true;
						case 10:operand_1_maxrange = 31;							//Mixed mode											
								operand_2_maxrange = 19;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								missing = true;
								missing_random = true;
					}
					
					// Multiplication 
			case 4: switch(sublevel)
					{
						case 1:	operand_1_maxrange = 0;				                //multiple of 2						
								operand_2_maxrange = 9;
								operand_1_minrange = 2;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 2: operand_1_maxrange = 0;								//multiple of 3											
								operand_2_maxrange = 9;
								operand_1_minrange = 3;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 3: operand_1_maxrange = 0;								//multiple of 4											
								operand_2_maxrange = 9;
								operand_1_minrange = 4;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 4: operand_1_maxrange = 0;								//multiple of 5											
								operand_2_maxrange = 9;
								operand_1_minrange = 5;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 5: operand_1_maxrange = 5;				                //multiplication upto 5							
								operand_2_maxrange = 4;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = false;
								missing_random = false;
						case 6:	operand_1_maxrange = 0;								//multiple of 6											
								operand_2_maxrange = 9;
								operand_1_minrange = 6;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 7: operand_1_maxrange = 0;								//multiple of 7											
								operand_2_maxrange = 9;
								operand_1_minrange = 7;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 8: operand_1_maxrange = 7;				                //multiplication upto 7							
								operand_2_maxrange = 6;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.subtraction;
								missing = false;
								missing_random = false;
						case 9: operand_1_maxrange = 0;								//multiple of 8											
								operand_2_maxrange = 9;
								operand_1_minrange = 8;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 10:operand_1_maxrange = 0;								//multiple of 9											
								operand_2_maxrange = 9;
								operand_1_minrange = 9;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
					}
					
					//Multiplication as well as revision
			case 5:
				if (sublevel >= 5)
				{
					operand_1_maxrange = 10;				                //revision 						
					operand_2_maxrange = 9;
					operand_1_minrange = 0;								
					operand_2_minrange = 0;
					missing = true;
					missing_random = true;
					multiple_arith_operation = true;
					multi_arith_operation_array.splice(0, multi_arith_operation_array.length - 1);    // Clearing array
					multi_arith_operation_array.push(ArithmeticOperation.subtraction);
					multi_arith_operation_array.push(ArithmeticOperation.sum);
					multi_arith_operation_array.push(ArithmeticOperation.multiplication);
				}
				switch(sublevel)
					{
						case 1: operand_1_maxrange = 0;								//multiple of 10											
								operand_2_maxrange = 9;
								operand_1_minrange = 10;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 2: operand_1_maxrange = 10;				                //multiplication upto 10						
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = false;
								missing_random = false;
						case 3: operand_1_maxrange = 10;				                //missing number						
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = true;
								missing_random = false;
						case 4: operand_1_maxrange = 10;				                //mixed mode 						
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.multiplication;
								missing = true;
								missing_random = true;
						case 5: 
						case 6: 
						case 7: 
						case 8: 
						case 9: 
						case 10:
					}
					
					// Divide
			case 6: switch(sublevel)
					{
						case 1: operand_1_maxrange = 9;								//Division by 2										
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 2;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 2: operand_1_maxrange = 9;								//Division by 3										
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 3;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 3: operand_1_maxrange = 9;								//Division by 4										
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 4;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 4: operand_1_maxrange = 9;								//Division by 5										
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 5;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 5: operand_1_maxrange = 9;								//Division upto 5 										
								operand_2_maxrange = 5;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 6: operand_1_maxrange = 9;								//Division by 6										
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 6;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 7: operand_1_maxrange = 9;								//Division by 7									
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 7;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 8: operand_1_maxrange = 9;								//Division by 8									
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 8;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 9: operand_1_maxrange = 9;								//Division by 9									
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 9;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 10:operand_1_maxrange = 9;								//Division upto 9 										
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false; 
					}
					
			case 7: 
				if (sublevel >= 7)
				{
					operand_1_maxrange = 10;				                //revision 						
					operand_2_maxrange = 9;
					operand_1_minrange = 0;								
					operand_2_minrange = 0;
					missing = true;
					missing_random = true;
					multiple_arith_operation = true;
					multi_arith_operation_array.splice(0, multi_arith_operation_array.length - 1);    // Clearing array
					multi_arith_operation_array.push(ArithmeticOperation.subtraction);
					multi_arith_operation_array.push(ArithmeticOperation.sum);
					multi_arith_operation_array.push(ArithmeticOperation.multiplication);
					multi_arith_operation_array.push(ArithmeticOperation.division);
				}
				switch(sublevel)
					{
						case 1: operand_1_maxrange = 9;								//Division by 10									
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 10;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 2: operand_1_maxrange = 9;								//Division by 11									
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 11;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 3: operand_1_maxrange = 9;								//Division by 12									
								operand_2_maxrange = 0;
								operand_1_minrange = 0;								
								operand_2_minrange = 12;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 4: operand_1_maxrange = 9;								//Division upto 12 										
								operand_2_maxrange = 12;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.division;
								missing = false;
								missing_random = false;
						case 5: operand_1_maxrange = 9;								//missing number 									
								operand_2_maxrange = 12;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.division;
								missing = true;
								missing_random = false;
						case 6: operand_1_maxrange = 9;								//mixed mode  										
								operand_2_maxrange = 12;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.division;
								missing = true;
								missing_random = true;
						case 7: 
						case 8: 
						case 9: 
						case 10: 
					}
					
			case 8: 
				factroid = true;    // Turning factroid mode true
				factroid_prime_number.splice(0, factroid_prime_number.length - 1);    // Clearing array
				if (sublevel >= 8)
				{
					factroid_prime_number.push(2);
					factroid_prime_number.push(3);
					factroid_prime_number.push(5);
					factroid_prime_number.push(7);
				}
				switch(sublevel)
					{
						case 1:
							factroid_prime_number.push(2);
						case 2:
							factroid_prime_number.push(3);
						case 3:
							factroid_prime_number.push(2);
							factroid_prime_number.push(3);
						case 4:
							factroid_prime_number.push(5);
						case 5:
							factroid_prime_number.push(2);
							factroid_prime_number.push(3);
							factroid_prime_number.push(5);
						case 6:
							factroid_prime_number.push(7);
						case 7:
							factroid_prime_number.push(5);
							factroid_prime_number.push(7);	
					}
			case 9: 
					operand_1_maxrange = 10;				              					
					operand_2_maxrange = 9;
					operand_1_minrange = 0;								
					operand_2_minrange = 0;
					missing = true;
					missing_random = true;
					multiple_arith_operation = true;
					multi_arith_operation_array.splice(0, multi_arith_operation_array.length - 1);  
					multi_arith_operation_array.push(ArithmeticOperation.subtraction);
					multi_arith_operation_array.push(ArithmeticOperation.sum);
					multi_arith_operation_array.push(ArithmeticOperation.multiplication);
					multi_arith_operation_array.push(ArithmeticOperation.division);
					factroid = true;    
					factroid_prime_number.splice(0, factroid_prime_number.length - 1);   
					factroid_prime_number.push(2);
					factroid_prime_number.push(3);
					factroid_prime_number.push(5);
					factroid_prime_number.push(7);
					pro_mode = true;                        // turning on pro mode 
		}
	}
	
	var temp:Float;   //for storing random result
	/**
	 * Function for generating non factroid question.
	 */
	private function newNonFactroidQuestion()
	{
		// Generating operands 
		for (x in 0...3)                                           // Just doing it in order to generate good random number 
		{
			question.operand1 = Math.ceil(Math.random() * operand_1_maxrange) + operand_1_minrange;
			question.operand2 = Math.ceil(Math.random() * operand_2_maxrange) + operand_2_minrange;
		}
		
		// Checking if multioperation is enabled and then generating corresponding operation(Arithmetic) randomly.
		if (multiple_arith_operation == true)
		{
				
			var random:Int = cast (Math.random() * 10000 ) % multi_arith_operation_array.length;
			this.arith_operation = multi_arith_operation_array[random];
		
		}
		switch(this.arith_operation)
		{
			case ArithmeticOperation.sum:	
						question.operation = this.arith_operation;
			case ArithmeticOperation.subtraction:
						if (question.operand1 >= question.operand2){}                   // Swapping operands so that answer is always positive. 
						else{
							var temp = question.operand1;
							question.operand1 = question.operand2;
							question.operand2 = temp;
						}
						question.operation = this.arith_operation;
			case ArithmeticOperation.multiplication:
						question.operation = this.arith_operation;
			case ArithmeticOperation.division:
						question.operand1 *= question.operand2;							// original operand1 will be answer of it.
						question.operation = this.arith_operation;	
		}
		
		if (missing_random == false)		// First check if mixed mode is enable 
		{
			if (missing == true)
				question.missing = true;
			else
				question.missing = false;
		}
		else								// Mixed mode is enable 
		{
			temp = Math.random();
			if ((temp<=0.25) || (temp>=0.5 && temp<=0.75))
					question.missing = true;
			else
				question.missing = false;
		}
		
		question.factroid = false ;                                   // Not a factroid question
		return question;
	}
	
	/**
	 * Function for generating factroid question.
	 */
	private function newFactroidQuestion()
	{
		var random:Int = cast (Math.random() * 10000 ) % factroid_prime_number.length;
		question.operand1 = factroid_prime_number[random];
		var temp:Int = cast (Math.random() * 10000 ) % factroid_prime_number.length;  //Used for generating second operand
		var power:Int;
		if(factroid_prime_number[temp]<5) 
			power= Math.ceil(Math.random() * 5);
		else
			power= Math.ceil(Math.random() * 3);
		question.operand2 = 1;
		//Calculating power 
		for (x in 0...power)
			question.operand2 *= factroid_prime_number[temp];
		question.factroid = true;					//It's a factroid question 
		question.operation = ArithmeticOperation.multiplication;
		return question;
	}
	
	/**
	 * Function for generating new question
	 */
	public function newQuestion()
	{
		if(pro_mode==false){
			if(factroid == false)                                        // Generate non factroid question
				return( newNonFactroidQuestion());
			else														// Generate factroid question 
				return (newFactroidQuestion());
		}
		else
		{
			var choice:Int = cast (Math.random() * 10000 ) % 2;
			if(choice == 0)                                       		 // Generate non factroid question
				return( newNonFactroidQuestion());
			else														// Generate factroid question 
				return (newFactroidQuestion());
		}
	}
}