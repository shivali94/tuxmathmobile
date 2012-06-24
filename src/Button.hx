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
	static public function button(content:String,color:Int,width:Float)
	{
		var text = new TextField();
		var text_format = new TextFormat('Arial', 30, 0xFFFFFF, true);
		text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		text.text = content;
		text_format.leftMargin = 0;
		text_format.rightMargin = 0;
		// Setting size of text 
		if (text.textWidth > width)
			while (text.textWidth > width)
			{
				text_format.size--;
				text.setTextFormat(text_format);
			}
		else
			while (text.textWidth < width)
			{
				text_format.size++;
				text.setTextFormat(text_format); 
			}
		text.height = text.textHeight;
		text.width = width;
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