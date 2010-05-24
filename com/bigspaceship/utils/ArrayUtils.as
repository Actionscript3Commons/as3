/**
 * ArrayUtils by Big Spaceship. 2009
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
	 * The <code>ArrayUtils</code> Class
	 * 
	 * 
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			Daniel Scheibel
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class ArrayUtils{

		/**
		 * The <code>shuffle</code> returns a shuffled array. The passed array itself does not change.
		 *  
		 * @param 	$array	Array that needs to bew shuffled.
		 * @return 			Array A new Array that contains the original values in a random order.
		 * 
		 */		
		public static function shuffle($array:Array):Array{
			//copy array:
			var a:Array = [].concat($array)
			//return shuffled array:
			return a.sort(__shuffleSort);;
		}
		
		private static function __shuffleSort($a:*,$b:*):Number{ 
			var random:int;
			while(random==0){
				random = MathUtils.getRandomInt(-1,1);
			}
			return random; 
		}
		
		
		/**
	     *  The <code>swap()</code> method swaps out two Objects within the same array.
		 * 	This Method doesn't create a copy of the passed array but changes it directly.
	     *
	     *  @param 	$array	Array	Specifies the Array to swap.
	     *  @param	$a		int 	Specifies the first index.
	     *  @param	$b 		int 	Specifies the second index.
	     *  @return 		Array 	Swapped Array.
	     */
		public static function swap($array:Array, $a:int, $b:int):Array{
			var temp:int = $array[$a];
			$array[$a] = $array[$b];
			$array[$b] = temp;
			return $array;
		}
		
		
		/**
	     *  The <code>unique()</code> method 
	     *	
		 * 	!! This Method currently might only work for Strings and Numbers !!
		 * 
	     *  @param $array 	Array	Specifies the Array from which to remove the duplicates.
	     *  @return 		Array	unique Array.
	     */
		public static function unique($array:Array):Array{
			var obj:Object = new Object;
			var i:Number = $array.length;
			var a:Array = new Array();
			var t:*;
			
			while(i--){
				t = $array[i];
				obj[t] = t;
			}
			
			for each(var item:* in obj){ a.push(item); }
			return a;
		}
	}
}