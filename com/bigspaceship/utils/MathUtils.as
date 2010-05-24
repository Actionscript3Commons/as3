/**
 * MathUtils by Big Spaceship. 2009
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
package com.bigspaceship.utils
{
	/**
	 * MathUtils
	 *
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class MathUtils
	{
		/**
		 * The <code>getRandomInt</code> method returns an int value between a Minimum and a Maximum int
		 * 
		 * @param 	$min_num	Number	Minimum Number
		 * @param 	$max_num	Number	Maximum Number
		 * @return 				int		Random int between 
		 * 
		 */		
		public static function getRandomInt($min_num:Number, $max_num:Number):int{
			$min_num = Math.ceil($min_num);
			$max_num = Math.floor($max_num);
			return $min_num + Math.floor(Math.random() * ($max_num + 1 - $min_num));
		}
		
		/**
		 * The <code>getRandomNumber</code> method returns Number value between a Minimum and a Maximum Number
		 * 
		 * @param	$min_num	Number
		 * @param	$max_num	Number
		 * @return				Number
		 * 
		 */		
		public static function getRandomNumber(min_num:Number, max_num:Number):Number{
			return min_num + (Math.random() * (max_num - min_num));
		}		
		
		/**
		 * The <code>normalize</code> method
		 * 
		 * @param $value 	Number
		 * @param $min		Number
		 * @param $max		Number
		 * @return 			Number 
		 * 
		 */		
		public static function normalize($value:Number, $min:Number, $max:Number):Number{
			return ($value - $min) / ($max - $min);
		}
		
		/**
		 * The <code>interpolate</code> method
		 * 
		 * @param $normValue	Number
		 * @param $min			Number
		 * @param $max			Number
		 * @return 				Number
		 * 
		 */		
		public static function interpolate($normValue:Number, $min:Number, $max:Number):Number{
			return $min + ($max - $min) * $normValue;
		}
		
		/**
		 * The <code>map</code> method
		 * 
		 * @param $value	Number
		 * @param $min1		Number
		 * @param $max1		Number
		 * @param $min2		Number
		 * @param $max2		Number
		 * @return 			Number
		 * 
		 */		
		public static function map($value:Number, $min1:Number, $max1:Number, $min2:Number, $max2:Number):Number{
			return interpolate( normalize($value, $min1, $max1), $min2, $max2);
		}
		
		/**
		 * The <code>findPreferredRatio</code> is used to find the correct ratio to fit content in a container using a maximum area.
		 *  
		 * @param $width		Number
		 * @param $height		Number
		 * @param $maxWidth		Number
		 * @param $maxHeight	Number
		 * @return 
		 * 
		 */
		public static function findPreferredRatio($width:Number, $height:Number, $maxWidth:Number, $maxHeight:Number):Number{
			var dw:Number = $maxWidth/$width;
			var dh:Number = $maxHeight/$height;
			return dw < dh ? dw : dh;
		}
		
		/**
	     *  The <code>limit()</code> method checks if a given value is within a specific range.
	     * 	It returns the value if it's within the range.
	     * 	It returns the min/max value if the value is lower/higher than the min/max. 
	     *
	     *  @param 		value	Number 	Specifies value.
	     *  @param 		min 	Number	Specifies the minimum value.
	     *  @param		max 	Number	Specifies the maximum value.
	     *  @return				Number 	within the given range.
	     */
		public static function limit($value:Number, $min:Number, $max:Number):Number{
			return Math.min(Math.max($min, $value), $max);
		}
		
		/**
	     *  The <code>roundNumber()</code> method 
	     *
	     *  @param	val		Number	Specifies the Number to round.
	     *  @param	digits	Number	Specifies the digits after the comma.
	     *  @return			Number
	     */  
		public static function roundNumber($val:Number, $digits:Number=0):Number{
			var factor:Number = Math.pow(10, $digits);
			return int($val*factor)/factor;
		}
		
		/**
	     *  The <code>degreesToRadians()</code> method calculates degrees to radians 
	     *
	     *  @param	degrees	Number	Specifies degrees to be converted.
	     *  @return 		Number	Radians.
	     */  
		public static function degreesToRadians($degrees:Number):Number{
			return $degrees*(Math.PI/180);
		}
		
		/**
	     *  The <code>degreesToRadians()</code> method calculates degrees to radians 
	     *
	     *  @param	radians	Number	Specifies radians to be converted.
	     *  @return 		Number	Degrees.
	     */  
		public static function radiansToDegrees(radians:Number):Number{
			return radians*(180/Math.PI);
		}
	}
}