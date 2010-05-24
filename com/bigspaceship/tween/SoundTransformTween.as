/**
 * SoundTransformTween by Big Spaceship. 2006-2009
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
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	public class SoundTransformTween extends EventDispatcher{
		
		protected static var __sp 	: Sprite = new Sprite();
		
		private var _channel		: SoundChannel;
		private var _tweens			: Array;
		private var _func			: Function;
		private var _stBegin		: SoundTransform;
		private var _stFinish		: SoundTransform;
		private var _time			: Number;
		private var _duration		: Number;
		
		public function get channel():SoundChannel{
			return _channel;
		}
		
		public function SoundTransformTween($channel:SoundChannel, $st1:SoundTransform, $st2:SoundTransform, $dur:Number, $func:Function = null):void{
			_channel = $channel;
			_tweens = new Array();
			_func = $func || function (t:Number, b:Number, c:Number, d:Number):Number { return c*t/d + b; };

			_stBegin = $st1;
			_stFinish = $st2;
			
			_time = 0;
			_duration = $dur;
			
			start();
		}
		
		public function start():void{
			__sp.addEventListener(Event.ENTER_FRAME, _nextStep)
		}
		
		public function stop():void{
			__sp.removeEventListener(Event.ENTER_FRAME, _nextStep);
			dispatchEvent(new Event(Event.CANCEL));
		}
		public function cancel():void{
			stop();
		}

		private function _nextStep($evt:Event = null):void{
			_time ++;
			if(_time > _duration){
				__sp.removeEventListener(Event.ENTER_FRAME, _nextStep);
				// dispatch finished event
				dispatchEvent(new Event(Event.COMPLETE));
			}else{
				(_channel) ? _channel.soundTransform = _getNextTransform() : SoundMixer.soundTransform = _getNextTransform();
			}
		}
		
		private function _getNextTransform():SoundTransform{
			var st:SoundTransform = new SoundTransform(
				_func(_time, _stBegin.volume, _stFinish.volume - _stBegin.volume, _duration), 
				_func(_time, _stBegin.pan, _stFinish.pan - _stBegin.pan, _duration)
			);
			
			return st;
		}
	}
}
