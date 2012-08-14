package tuxkids;

/**
 * ...
 * @author Deepak Aggarwal
 */
import nme.filters.DropShadowFilter;
import nme.filters.GlowFilter;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.display.Shape;
import nme.display.Sprite;

 /**
  * Static class used for creating buttons for menus.
  */
class Button 
{
	/**
	 * Function for creating button. <br>
	 * @param	content	:- Data to be shown inside the buttons. <br>
	 * @param	color	:- Button color. <br>
	 * @param	Height  :- Button height.
	 */
	static public function button(content:String,color:Int,Height:Float)
	{
		var text = new TextField();										// New textfield for adding text.
		var text_format = new TextFormat('Arial', 90, 0xFFFFFF, true);
		text_format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = text_format;
		text.selectable = false;
		text.text = content;
		// Setting size of text. 
		if (text.textHeight > Height)
			while (text.textHeight > Height)
			{
				text_format.size-=2;
				text.setTextFormat(text_format);
			}
		else
			while (text.textHeight < Height && text.textHeight < 254)
			{
				text_format.size+=2;
				text.setTextFormat(text_format); 
			}
		text.height = text.textHeight;
		text.width = text.textWidth * 1.1;
		// Drawing button background.
		var shape:Shape = new Shape();
		var sprite:Sprite = new Sprite();
		shape.graphics.clear();
		shape.graphics.beginFill(color);
		shape.graphics.drawRect(0, 0, text.width, text.height);
		sprite.addChild(shape);
		shape.graphics.endFill();
		// Adding text.
		sprite.addChild(text);
		// Applying glow effect.
		sprite.filters = [new GlowFilter(color, 1, 6, 6, 2, 1)];
		// Returning sprite containing button.
		return sprite;										
	}
}