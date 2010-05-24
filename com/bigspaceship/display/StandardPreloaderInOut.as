/**
 * StandardPreloaderInOut by Big Spaceship. 2010
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

package com.bigspaceship.display
{	
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * The <code>StandardPreloaderInOut</code> Class
	 * 
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Jamie Kosoy, Daniel Scheibel
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class StandardPreloaderInOut extends StandardInOut{	
		
		public var animateOutOnSetComplete:Boolean = false;
		
		private var _targetFrame		:Number;
		private var _progress_mc 		:MovieClip;
		
		public function StandardPreloaderInOut($mc:MovieClip):void {
			super($mc);
		}
		
		override protected function _onAnimateInStart() : void{
			if(_progress_mc)_progress_mc.gotoAndStop(1);
		}
		
		override protected function _onAnimateIn():void{
			_progress_mc = _mc.progress_mc;
			_progress_mc.addEventListener(Event.ENTER_FRAME, _onProgressEnterFrame);
			_progress_mc.stop();
			
		}
		
		public function updateProgressPercent($percent:Number):void{
			if(_progress_mc){
				_targetFrame = Math.floor(_progress_mc.totalFrames * $percent);
				//Out.debug(this, "updateProgressPercent :: " +  _progress_mc.currentFrame + "/" +_progress_mc.totalFrames + " :: " + _targetFrame +' :: '+$percent);
			}else{
				//Out.debug(this, "updateProgressPercent :: _progress_mc does NOT EXIST!");
			}
			
		}
		
		public function updateProgress($bytesLoaded:Number, $bytesTotal:Number, $itemsLoaded:Number, $itemsTotal:Number):void{
			var framesPerItem:Number = Math.floor(_mc.progress_mc.totalFrames/($itemsTotal));
			var pct:Number = $bytesLoaded/$bytesTotal;
			_targetFrame = Math.floor(framesPerItem * pct) + (framesPerItem * $itemsLoaded);
			//	Out.debug(this, "updatePreloader :: " + $bytesLoaded + "/" + $bytesTotal + " :: " + $itemsLoaded + "/" + $itemsTotal + " :: " + preloader_mc.progress_mc.currentFrame + "/" + preloader_mc.progress_mc.totalFrames + " :: " + targetFrame);
		}
		
		// loading is complete, so make sure the preloader progress clip plays away.
		public function setComplete():void{
			//Out.debug(this, 'setComplete: state:'+_curState+', currentFrame'+_progress_mc.currentFrame);
			if((_curState == AnimationState.IN && _curState != AnimationState.OUT_START && (_curState != AnimationState.OUT && _curState != AnimationState.INIT) )){
				_progress_mc.removeEventListener(Event.ENTER_FRAME, _onProgressEnterFrame);
				if(_progress_mc.currentFrame == _progress_mc.totalFrames){
					dispatchEvent(new Event(Event.COMPLETE));
					if(animateOutOnSetComplete){
						animateOut();
					}
				}else{
					_progress_mc.addEventListener(Event.COMPLETE, _onProgressBarComplete);
					_targetFrame = 9999999999;
					_progress_mc.play();
				}
			}else if((_curState == AnimationState.OUT || _curState == AnimationState.INIT) && _dispatchCompleteOnUnchangedState){
				if(animateOutOnSetComplete){
					dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
				}else{
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			
		}
		
		private function _onProgressEnterFrame($evt:Event):void{
			if(_progress_mc)(_targetFrame > _progress_mc.currentFrame) ? _progress_mc.play() : _progress_mc.stop();
		}
		
		private function _onProgressBarComplete($evt:Event):void{
			_progress_mc.removeEventListener(Event.COMPLETE,_onProgressBarComplete);
			dispatchEvent(new Event(Event.COMPLETE));
			if(animateOutOnSetComplete){
				animateOut();
			}
		}
		

	}
}