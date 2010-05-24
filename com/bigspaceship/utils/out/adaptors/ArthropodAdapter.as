/**
 * ArthropodAdapter by Big Spaceship. 2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2010 Big Spaceship, LLC
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
package com.bigspaceship.utils.out.adaptors
{
	import com.carlcalderon.arthropod.Debug;
	
	import flash.display.Bitmap;
	
	/**
	 * A bridge for the Out class with the Athropod debugger (http://arthropod.stopp.se/)
	 * 
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Charlie Whitney
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 */	
	
	public class ArthropodAdapter implements IOutAdapter
	{
		private var _traceObjects	:Boolean = false;
		
		public function set traceAsObjects($val:Boolean):void { _traceObjects = $val; }
		
		/**
		 * Construct
		 * Pass in an optional parameter to trace objects using special arthropod
		 * debug features as opposed to strings which is the default
		 */		
		public function ArthropodAdapter($traceAsObjects:Boolean=false) {
			_traceObjects = $traceAsObjects;
		};
		
		/**
		 * Clear the viewer input 
		 */		
		public function clear():void {
			Debug.clear();
		};
		
		/**
		 * Called when it receives data for output to debugger  
		 */		
		public function output($prefix:String, $level:String, ...$objects):void {
			var output:String = $prefix;
			
			for(var i:String in $objects){
				output += " "+$objects[i];
			}
			
			if(_traceObjects && $objects[0] is Array){	Debug.array($objects[0]); return;	}
			if(_traceObjects && $objects[0] is Bitmap){	Debug.bitmap($objects[0]); return;	}
			
			switch($level)
			{
				case "ERROR" :
					Debug.error(output);
					break;
				case "WARNING" :
					Debug.warning(output);
					break;
				case "FATAL" :
					Debug.log(output, Debug.RED);
					break;
				case "DEBUG" :
					Debug.log(output, Debug.PINK);
					break;
				case "STATUS" :
					Debug.log(output, Debug.GREEN);
					break;
				case "INFO" :
					Debug.log(output);
					break;
				case "" :
				case "OBJECT" :
					Debug.log(output, 0xBCF100);
					break;
				default:
					break;
			}
		};
	}
}