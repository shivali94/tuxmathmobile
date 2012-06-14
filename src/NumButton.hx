package ;
import nme.display.Shape;
import nme.events.TouchEvent;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormatAlign;
import nme.display.Sprite;
import nme.Lib;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.media.Sound;
import nme.Assets;
import nme.feedback.Haptic;

/**
 * ...
 * @author Deepak Aggarwal
 */

class Constant
{
	public static var width:Int;
	public static var height:Int;
	public static var border:Int;
	public static var text_format;
	public static var consoleButton:Sound;
	public static function initialize()
	{
		width = cast Lib.current.stage.stageWidth * 0.2 / 2;                   // Will be 10% of screen size
		height =cast Lib.current.stage.stageHeight * 0.95 / 5;					// Will cover about 95% of screen height 
		border = cast ((Lib.current.stage.stageHeight - height * 5) / 6);
		consoleButton = Assets.getSound("assets/sounds/tock.wav");
		
		// Setting size of content of buttons 
		var text = new TextField();
		text_format = new TextFormat('Arial', 30, 0xFFFFFF, true);
		text.defaultTextFormat = text_format;
		text.text = "8";
		text_format.leftMargin = 0;
		text_format.rightMargin = 0;
		var textSize:Float = height ;                         //  Will cover 100% of button height
															  // TODO check it later if there is some problem in text problem at higher resolution
		// Setting size of text 
		if (text.textHeight > textSize)
			while (text.textHeight > textSize)
			{
				text_format.size--;
				text.setTextFormat(text_format);
			}
		else
			while (text.textHeight < textSize)
			{
				text_format.size++;
				text.setTextFormat(text_format);
			}
	}
}

class Button extends Sprite
{
	var shape:Shape;
	var value:Int;
	var text:TextField;
	public function new(val:Int)
	{
		super();
		shape = new Shape();
		value = val;
		text = new TextField();
		text.defaultTextFormat = Constant.text_format;
		text.selectable = false;
		text.text = value + "";          // Setting value make sure you do that before calculating x and y co-orfinate of it.
		text.x = (Constant.width - text.textWidth) / 2;
		//text.y = (Constant.height - text.textHeight) / 2;      // TODO no need to do this as it is automatically centered while ajusting height by margin               
		touchEnd();	
		addEventListener(TouchEvent.TOUCH_BEGIN,function(ev:TouchEvent){
			touchBegin();
			Constant.consoleButton.play();
		});
		addEventListener(TouchEvent.TOUCH_END,function(ev:TouchEvent){
			touchEnd();
		});
		
		/*
		addEventListener(MouseEvent.MOUSE_DOWN,function(ev:MouseEvent){
			touchBegin();
			Constant.consoleButton.play();
			Haptic.vibrate(0, 100);
		});
		addEventListener(MouseEvent.MOUSE_UP,function(ev:MouseEvent){
			touchEnd();
		});
		*/
	
	}
	public function touchBegin()
	{
		shape.graphics.clear();
		shape.graphics.beginFill(0x96540C);
		shape.alpha = 0.3;
		shape.graphics.drawRect(0, 0, Constant.width, Constant.height);
		addChild(shape);
		shape.graphics.endFill();
		addChild(text);
	}
	public function touchEnd()
	{
		shape.graphics.clear();
		shape.graphics.beginFill(0x2068C7);
		shape.alpha = 0.3;
		shape.graphics.drawRect(0, 0, Constant.width, Constant.height);
		addChild(shape);
		shape.graphics.endFill();
		addChild(text);
	}
}

class NumButton extends Sprite 
{
	public function new() 
	{
		super();
		Constant.initialize();
		var x:Int = 0;
		for (x in 0...10)
		{
			var temp:Button = new Button(x);
			if (x < 5)
				temp.x = 0
			else
				temp.x = Lib.current.stage.stageWidth - Constant.width;
			temp.y = Constant.height * (x%5) + Constant.border * (x%5 + 1);
			addChild(temp);
		}
	}
	
}