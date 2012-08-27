
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

import nme.display.BitmapData;
import nape.phys.Body;
import nape.geom.Vec2;
import nape.geom.AABB;
import nape.geom.MarchingSquares;
import nme.display.Bitmap;
import nme.display.PixelSnapping;
import nape.shape.Polygon;
import nme.display.Sprite;

/**
 * ...
 * @author Deepak Aggarwal
 */

 /**
  * Right now it's of no use.
  */
class BitmapToBody 
{
	//take a BitmapData object with alpha channel
    //and produce a nape body from the alpha threshold
    //with input bitmap used to create an assigned graphic displayed
    //appropriately
	public static function bitmapToBody(bitmap:BitmapData, ?threshold = 0x80, ?granularity:Vec2 = null):Body {
		var body = new Body();
		var bounds = new AABB(0, 0, bitmap.width, bitmap.height);
		function iso(x:Float,y:Float):Float {
			//take 4 nearest pixels to interpolate linearlly
			var ix = Std.int(x); var iy = Std.int(y);
            //clamp in-case of numerical inaccuracies
            if (ix < 0) ix = 0; if (iy < 0) iy = 0;  
			if (ix >= bitmap.width)  ix = bitmap.width - 1;
            if (iy >= bitmap.height) iy = bitmap.height - 1;
            //
            var fx = x - ix; var fy = y - iy;
			var a11 = threshold - (bitmap.getPixel32(ix, iy) >>> 24);
            var a12 = threshold - (bitmap.getPixel32(ix + 1, iy) >>> 24);
            var a21 = threshold - (bitmap.getPixel32(ix, iy + 1) >>> 24);
            var a22 = threshold - (bitmap.getPixel32(ix + 1, iy + 1) >>> 24);
			return a11 * (1 - fx) * (1 - fy) + a12 * fx * (1 - fy) + a21 * (1 - fx) * fy + a22 * fx * fy;
		}
		//iso surface is smooth from alpha channel + interpolation
		//so less iterations are needed in extraction
        var grain = if (granularity == null) new Vec2(8, 8) else granularity;
        var polys = MarchingSquares.run(iso, bounds, grain, 1);
        for (p in polys) {
			var qolys = p.convex_decomposition();
            for (q in qolys)
			body.shapes.add(new Polygon(q));
		}
		//want to align body to it's centre of mass
		//and also have graphic offset correctly
        //easiest way is to wrap the graphic in another.
        var anchor = body.localCOM.mul( -1);
        body.translateShapes(anchor);
        var wrap:Sprite = new Sprite();
        var bmp = new Bitmap(bitmap, PixelSnapping.AUTO, true);
        wrap.addChild(bmp);
        bmp.x = anchor.x;
        bmp.y = anchor.y;   
        body.graphic = wrap;
        return body;
    }	
}