/**
 * ColorUtils by Big Spaceship. 2009
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2009 Big Spaceship, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
package com.bigspaceship.utils{
	
	

	/**
	 * ColorUtils
	 *
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			Daniel Scheibel
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class ColorUtils{
		
		
		public function ColorUtils(){
			/* 
			var argb:Number = 0xFFC97B33;
			// mask the alpha bits, then shift them to the least significant bits
			// shifting 6 hex digits, so 24 binary digits
			var alpha:Number = (argb & 0xFF000000) >>> 24;
			trace("Alpha: "+alpha.toString(16));
			// isolate Red:
			var red:Number = (argb & 0x00FF0000) >>> 16;
			trace("Red: "+red.toString(16));
			// isolate Green:
			var green:Number = (argb & 0x0000FF00) >>> 8;
			trace("Green: "+green.toString(16));
			// isolate Blue:
			var blue:Number = argb & 0x000000FF;
			trace("Blue: "+blue.toString(16));
			 */
		}
		

		/**
		 * HexToRGB: returns the RGB (as Object) for the specified HEX value
		 * 
		 * @param $hex
		 * @return 
		 * 
		 */		
		public static function hexToRGB($hex:Number):Object{
			return {r:$hex >> 16, g:($hex >> 8) & 0xff, b:$hex & 0xff};
		}
         
		/**
		 * getHexStr: returns a string representing the HEX value for the specified R,G,B values
		 * 
		 * @param $prefix
		 * @param $r
		 * @param $g
		 * @param $b
		 * @return 
		 * 
		 */		
		public static function getHexStr($prefix:String, $r:Number, $g:Number, $b:Number ):String{
			return  $prefix + twoDigit($r.toString(16)) + twoDigit($g.toString(16)) + twoDigit($b.toString(16));
		}
		
		/**
		 * getHex: returns the HEX value for the specified R,G,B values 
		 * 
		 * @param $r
		 * @param $g
		 * @param $b
		 * @return 
		 * 
		 */
		public static function getHex($r:Number, $g:Number, $b:Number):Number{
			return $r << 16 | $g << 8 | $b;
		}
		
		/**
		 * twoDigit: adds "0" in front if the string is only
		 * one digit, also useful for converting date time strings 
		 * 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function twoDigit(str:String):String{
			return str.length == 1 ? ("0" + str) : str ;
		}

		/**
		 * 
		 * @param $hex
		 * @param $offsetHex
		 * @return 
		 * 
		 */		
		public static function getRandomHue($hex:Number, $offsetHex:Number):Number{
			var color:Number = ((Math.random()* 0xffffff) & $hex) | $offsetHex ;
			return color;
		}

	}
}