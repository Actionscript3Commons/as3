/**
 * ColorTransformTween by Big Spaceship. 2006
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2006-2009 Big Spaceship, LLC
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

package com.bigspaceship.tween{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class ColorTransformTween extends EventDispatcher{
		
		protected static var __sp 	: Sprite = new Sprite();

		private var _dispObj	: DisplayObject;
		private var _transform	: Transform;
		private var _tweens		: Array;
		private var _func		: Function;
		private var _ctBegin	: ColorTransform;
		private var _ctFinish	: ColorTransform;
		private var _time		: Number;
		private var _duration	: Number;
		
		public function ColorTransformTween($obj:DisplayObject, $ct1:ColorTransform, $ct2:ColorTransform, $dur:Number, $func:Function = null):void{
			_dispObj = $obj;
			_transform = $obj.transform;
			_tweens = new Array();
			_func = $func || function (t:Number, b:Number, c:Number, d:Number):Number { return c*t/d + b; };

			_ctBegin = $ct1;
			_ctFinish = $ct2;
			
			_time = 0;
			_duration = $dur;
			
			start();
		};
		
		public function start():void{
			__sp.addEventListener(Event.ENTER_FRAME, _nextStep);
		};
		
		public function stop():void{
			__sp.removeEventListener(Event.ENTER_FRAME, _nextStep);
		};

		private function _nextStep($evt:Event = null):void{
			_time ++;
			if(_time > _duration){
				stop();
				// dispatch finished event
			}else{
				_transform.colorTransform = _getNextTransform();
			}
		};
		
		private function _getNextTransform():ColorTransform{
			var ctNew:ColorTransform = new ColorTransform(
				_func(_time, _ctBegin.redMultiplier, _ctFinish.redMultiplier - _ctBegin.redMultiplier, _duration), 
				_func(_time, _ctBegin.greenMultiplier, _ctFinish.greenMultiplier - _ctBegin.greenMultiplier, _duration), 
				_func(_time, _ctBegin.blueMultiplier, _ctFinish.blueMultiplier - _ctBegin.blueMultiplier, _duration), 
				_func(_time, _ctBegin.alphaMultiplier, _ctFinish.alphaMultiplier - _ctBegin.alphaMultiplier, _duration), 
				_func(_time, _ctBegin.redOffset, _ctFinish.redOffset - _ctBegin.redOffset, _duration), 
				_func(_time, _ctBegin.greenOffset, _ctFinish.greenOffset - _ctBegin.greenOffset, _duration), 
				_func(_time, _ctBegin.blueOffset, _ctFinish.blueOffset - _ctBegin.blueOffset, _duration), 
				_func(_time, _ctBegin.alphaOffset, _ctFinish.alphaOffset - _ctBegin.alphaOffset, _duration)
			);
			
			return ctNew;
		};
		
		
	}
}
