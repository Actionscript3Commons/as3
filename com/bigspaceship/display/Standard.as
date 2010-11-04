/**
 * Standard by Big Spaceship. 2009
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
 
package com.bigspaceship.display
{
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	/**
	 * Standard
	 *
	 * @param			(classes, interfaces, methods and constructors only)
	 * @return			(methods only)
	 * @copyright 		2010 Big Spaceship, LLC 	(classes and interfaces only, required)
	 * @author			Daniel Scheibel (classes and interfaces only, required)
	 * @version			1.0 (classes and interfaces only, required)
	 * @see         
	 * @since       		
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	 
	public class Standard extends EventDispatcher implements IStandard
	{
		
		protected var _curState:String;
		protected var _id:String;
		protected var _mc:MovieClip;
		protected var _useWeakReference:Boolean;
		
		public function get id():String{ 
			return _id; 
		}
		public function set id($val:String):void{
			_id = $val;
		}
		public function get mc():MovieClip{ 
			return _mc; 
		}
		public function get curState():String{ 
			return _curState; 
		}
		public function get state():String{ 
			return _curState; 
		}
		public function get useWeakReference():Boolean{ 
			return _useWeakReference; 
		}
		
		public function Standard($mc:MovieClip, $useWeakReference:Boolean = false){
			_mc = $mc;
			_useWeakReference = $useWeakReference;
		}
		
		public function destroy():void{
			_mc = null;
			_id = null;
			_curState = null;
		}
	}
}