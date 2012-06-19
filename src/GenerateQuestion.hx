package ;

/**
 * ...
 * @author Deepak Aggarwal
 */
/*====================================================================================================================
	This class will be used for generating question within the game.
	1. First instance of this class is made
	2. Then setQuestions() is used to set questions according to Level and Sublevel.
	3. newQuestion() function is used to generate new question.
  ====================================================================================================================*/
class GenerateQuestion 
{
	var operand_1_maxrange:Int;
	var operand_2_maxrange:Int;	
	var operand_1_minrange:Int;
	var operand_2_minrange:Int;
	var arith_operation:ArithmeticOperation;
	var question:Question;
	public function new() 
	{
		question = new Question();
	}
	
	// unction used to set Level and sublevel
	public function setQuestions(level:Int , sublevel:Int)
	{
		switch(level)
		{
			case 1: switch(sublevel)
					{
						case 1:	operand_1_maxrange = 2;				                //Sum upto 5							
								operand_2_maxrange = 3;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
						case 2: operand_1_maxrange = 6;								//Sum upto 10											
								operand_2_maxrange = 4;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
						case 3: operand_1_maxrange = 8;								//Sum upto 15											
								operand_2_maxrange = 7;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
						case 4: operand_1_maxrange = 11;							//Sum upto 20											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
						case 5: operand_1_maxrange = 41;							//Sum of 2 digit numbers 											
								operand_2_maxrange = 39;
								operand_1_minrange = 10;								
								operand_2_minrange = 10;
								arith_operation = ArithmeticOperation.sum;
						case 6:	operand_1_maxrange = 11;							//Missing number											
								operand_2_maxrange = 9;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
								question.missing = true;
						case 7:	operand_1_maxrange = 51;							//Mixed numbers 											
								operand_2_maxrange = 49;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
						case 8: operand_1_maxrange = 51;							//Mixed numbers 											
								operand_2_maxrange = 49;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
						case 9: operand_1_maxrange = 51;							//Mixed numbers 											
								operand_2_maxrange = 49;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
						case 10:operand_1_maxrange = 51;							//Mixed numbers 											
								operand_2_maxrange = 49;
								operand_1_minrange = 0;								
								operand_2_minrange = 0;
								arith_operation = ArithmeticOperation.sum;
					}
					
			case 2: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
					
			case 3: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
				
			case 4: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
					
			case 5: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
					
			case 6: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
					
			case 7: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
					
			case 8: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
			
			case 9: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
					
			case 10: switch(sublevel)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						case 10:
					}
		}
	}
	public function newQuestion()
	{
		question.operand1 = Math.ceil(Math.random() * operand_1_maxrange) + operand_1_minrange;
		question.operand2 = Math.ceil(Math.random() * operand_2_maxrange) + operand_2_minrange;
		question.operation = this.arith_operation;
		return question;
	}
}