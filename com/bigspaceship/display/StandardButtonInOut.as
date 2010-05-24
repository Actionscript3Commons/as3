/**
 * StandardButtonInOut by Big Spaceship. 2009
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
	import com.bigspaceship.events.AnimationEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * This class combines the BigScreen IN/OUT label functionality
	 * to the StandardButton.
	 * 
 	 * @copyright 	2009 Big Spaceship, LLC
	 * @author 		Daniel Scheibel
	 */	
	public class StandardButtonInOut extends Standard
	{
		
		private var _standardInOut:StandardInOut;
		private var _standardBtn:StandardButton;
		
		private var _btn:DisplayObject;
		
		private var _currentStateKeeper:Standard;
		
		public function get dispatchCompleteOnUnchangedState():Boolean{	
			return _standardInOut.dispatchCompleteOnUnchangedState;	
		}
		public function set dispatchCompleteOnUnchangedState($b:Boolean):void{
			_standardInOut.dispatchCompleteOnUnchangedState = $b;
		}
		
		override public function get state():String{
			return _currentStateKeeper.state;
		}
		
		
		//====================================================
		// CONSTRUCTOR
		/**
		 * Great! Create! Celebrate!
		 * @param $mc
		 */		
		public function StandardButtonInOut($mc:MovieClip, $btn:DisplayObject = null){
			super($mc);
			_btn = $btn;
			_standardInOut = new StandardInOut($mc);
			_standardInOut.addEventListener(AnimationEvent.IN, _onAnimateIn_handler);
			//_standardBtn = new StandardButton($mc, $btn);
			_currentStateKeeper = _standardInOut;
		}
		
		
		//====================================================
		// ANI IN/OUT
		/**
		 * Starts the in animation.
		 */	
		public function animateIn():void{
			_standardInOut.animateIn();
		}
		
		/**
		 * Starts the out animation.
		 */		
		public function animateOut():void{
			_standardInOut.animateOut();
			_standardBtn.destroy();
			_standardBtn = null;
			_currentStateKeeper = _standardInOut;
		};
		
		
		//====================================================
		// EVENT HANDLERS
		
		private function _onAnimateIn_handler($evt:Event):void{
			// sk: only create the button if it doesn't exist
			if(!_standardBtn)
			{
				_standardBtn = new StandardButton(_mc, _btn);
				_standardBtn.addEventListener(MouseEvent.CLICK, dispatchEvent);
			}
			//_currentStateKeeper = _standardBtn;
		}
		
		
	}
	
}