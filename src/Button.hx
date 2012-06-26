package ;

/**
 * ...
 * @author Deepak Aggarwal
 */
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.display.Shape;
import nme.display.Sprite;

 // Used for creating Menu buttons 
class Button 
{
	static public function button(content:String,color:Int,Height:Float)
	{
		var text = new TextField();
		var text_format = new TextFormat('Arial', 30, 0xFFFFFF, true);
		text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		text.text = content;
		// Setting size of text 
		if (text.textHeight > Height)
			while (text.textHeight > Height)
			{
				text_format.size--;
				text.setTextFormat(text_format);
			}
		else
			while (text.textHeight < Height)
			{
				text_format.size++;
				text.setTextFormat(text_format); 
			}
		text.height = text.textHeight;
		text.width = text.textWidth;
		var shape:Shape = new Shape();
		var sprite:Sprite = new Sprite();
		shape.graphics.clear();
		shape.graphics.beginFill(color);
		shape.graphics.drawRect(0, 0, text.textWidth, text.textHeight);
		sprite.addChild(shape);
		shape.graphics.endFill();
		// Adding text
		sprite.addChild(text);
		return sprite;
	}
}