/**
 * StandardButton by Big Spaceship. 2008-2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2008-2010 Big Spaceship, LLC
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
	import com.bigspaceship.utils.MathUtils;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Dispatched when button is clicked.
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="click", type="flash.events.MouseEvent")]
	
	/**
	 * Dispatched when user rolls over button.
	 * 
	 * @eventType flash.events.Event
	 **/
	[Event(name="roll_over", type="flash.events.MouseEvent")]
	
	/**
	 * Dispatched when user rolls out button.
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="roll_out", type="flash.events.MouseEvent")]
	
	/* list of dispatching Events not finished yet */
	

	/**
	 * The <code>StandardButton</code> Class
	 * 
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Jamie Kosoy, Daniel Scheibel
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class StandardButton extends Standard{
		
		public var mirrorOverOutAnimations:Boolean = false;
		
		protected var _labels_obj:Object;
		
		protected var _active:Boolean = true;
		protected var _btn:DisplayObject;
		
		protected var _selectAnimStartLabel:String = 'ROLL_OVER_START';
		protected var _deselectAnimStartLabel:String = 'ROLL_OUT_START';
		
		
		
		public function get btn():DisplayObject{
			return _btn;
		}
		public function get selectAnimStartLabel():String{
			return _selectAnimStartLabel;
		}
		public function set selectAnimStartLabel($val:String):void{
			_selectAnimStartLabel = $val;
		}
		public function get deselectAnimStartLabel():String{
			return _deselectAnimStartLabel;
		}
		public function set deselectAnimStartLabel($val:String):void{
			_deselectAnimStartLabel = $val;
		}
		public function get active():Boolean{
			return _active;
		}
		public function set active($val:Boolean):void{
			if($val && !_active){
				addBtnEventListeners();
			}else if (!$val && _active){
				removeBtnEventListeners();
			} 
		}
	
		public function StandardButton($mc:MovieClip, $btn:DisplayObject = null, $useWeakReference:Boolean = false){
			super($mc, $useWeakReference);
			if($btn){
				_btn = $btn;
			}else if (_mc.btn){
				_btn = _mc.btn;
			}else{
				_btn = _mc;
			}
			_curState = AnimationState.INIT;
			
			// ADD LISTENERS TO HANDLE BUTTON EVENTS
			addBtnEventListeners();
			
			// ADD LISTENERS FOR TIMELINE ANIMATION EVENTS 
			var labels:Array = _mc.currentLabels;
			_labels_obj = new Object();
			for (var i:uint = 0; i < labels.length; i++) {
				var label:FrameLabel = labels[i];
				_labels_obj[label.name] = label.frame;
				switch(label.name){
					case 'ROLL_OVER':
						_mc.addEventListener(AnimationEvent.ROLL_OVER_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.ROLL_OVER, _onTimelineEvent_handler, false, 0, _useWeakReference);
						break;
					case 'ROLL_OUT':
						_mc.addEventListener(AnimationEvent.ROLL_OUT_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.ROLL_OUT, _onTimelineEvent_handler, false, 0, _useWeakReference);
						break;
					case 'CLICK':
						_mc.addEventListener(AnimationEvent.CLICK_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.CLICK, _onTimelineEvent_handler, false, 0, _useWeakReference);
						break;
					case 'MOUSE_UP':
						_mc.addEventListener(AnimationEvent.MOUSE_UP_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.MOUSE_UP, _onTimelineEvent_handler, false, 0, _useWeakReference);
						break;
					case 'MOUSE_DOWN':
						_mc.addEventListener(AnimationEvent.MOUSE_DOWN_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.MOUSE_DOWN, _onTimelineEvent_handler, false, 0, _useWeakReference);
						break;
					case 'IN':
						_mc.addEventListener(AnimationEvent.IN_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.IN, _onTimelineEvent_handler, false, 0, _useWeakReference);
					case 'IDLE':
						_mc.addEventListener(AnimationEvent.IDLE, _onTimelineEvent_handler, false, 0, _useWeakReference);
				}
			}
			_mc.addEventListener(AnimationEvent.UPDATE, _onTimelineEvent_handler, false, 0, _useWeakReference);
			
		}
		
		public function deselect():void{
			if(!active){
				_mc.gotoAndPlay(_deselectAnimStartLabel);	
			}
			_btn.visible = true;
			active = true;
		}
		public function select():void{
			if(active){
				_mc.gotoAndPlay(_selectAnimStartLabel);
			}
			_btn.visible = false;
			active = false;
		}
		
		override public function destroy():void{
			
			removeBtnEventListeners();
			_btn = null;
			
			_mc.removeEventListener(AnimationEvent.IN, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.IN_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.IDLE, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OUT_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OUT, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OVER_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OVER, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.CLICK_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.CLICK, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_DOWN_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_DOWN, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_UP_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_UP, _onTimelineEvent_handler);
			
			super.destroy();
		}
		
		protected function addBtnEventListeners():void{
			var labels:Array = _mc.currentLabels;
			for (var i:uint = 0; i < labels.length; i++) {
			    var label:FrameLabel = labels[i];
			   
			    switch(label.name){
			    	case 'ROLL_OVER':
			    	case 'ROLLOVER':
			    		_btn.addEventListener(MouseEvent.ROLL_OVER, _onMouseRollOver_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'ROLL_OUT':
			    	case 'ROLLOUT':
			    		_btn.addEventListener(MouseEvent.ROLL_OUT, _onMouseRollOut_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'CLICK':
			    		_btn.addEventListener(MouseEvent.CLICK, _onMouseClick_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'MOUSE_UP':
			    		_btn.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'MOUSE_DOWN':
			    		_btn.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown_handler, false, 0, _useWeakReference);
			    		break;
				case 'SELECT':
					_selectAnimStartLabel = "SELECT";
					break;
				case 'DESELECT':
					_deselectAnimStartLabel = "DESELECT";
					break;
			    }
			}

			_btn.addEventListener(MouseEvent.ROLL_OVER, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.ROLL_OUT, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.MOUSE_UP, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.CLICK, dispatchEvent, false, 0, _useWeakReference);

			// sk: active? at this point, we are
			_active = true;
		}
		
		protected function removeBtnEventListeners():void{
			_btn.removeEventListener(MouseEvent.ROLL_OVER, _onMouseRollOver_handler);
			_btn.removeEventListener(MouseEvent.ROLL_OVER, dispatchEvent);
			_btn.removeEventListener(MouseEvent.ROLL_OUT, _onMouseRollOut_handler);
			_btn.removeEventListener(MouseEvent.ROLL_OUT, dispatchEvent);
			_btn.removeEventListener(MouseEvent.CLICK, _onMouseClick_handler);
			_btn.removeEventListener(MouseEvent.CLICK, dispatchEvent);
			_btn.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp_handler);
			_btn.removeEventListener(MouseEvent.MOUSE_UP, dispatchEvent);
			_btn.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown_handler);
			_btn.removeEventListener(MouseEvent.MOUSE_DOWN, dispatchEvent);

			// sk: active? at this point, we are not
			_active = false;
		}
		
		
		protected function _onTimelineEvent_handler($evt:AnimationEvent) : void{
			_curState = $evt.type;
			switch ($evt.type) {
				case AnimationEvent.IN:
				case AnimationEvent.IDLE:
					_mc.stop();
					break;
				case AnimationEvent.ROLL_OVER:
					_mc.stop();
					break;
				case AnimationEvent.ROLL_OUT:
					_mc.stop();
					_mc.gotoAndStop("IDLE");
					break;
				case AnimationEvent.CLICK:
					_mc.stop();
					break;
				case AnimationEvent.MOUSE_DOWN:
					_mc.stop();
					break;
				case AnimationEvent.MOUSE_UP:
					_mc.stop();
					break;
			}
			dispatchEvent($evt);
		}
		
		private function _onMouseRollOver_handler($evt:MouseEvent):void{
			var shift:int = 0;
			if( mirrorOverOutAnimations && _curState == AnimationState.ROLL_OUT_START){
				var framesPlayed:int = _mc.currentFrame - _labels_obj['ROLL_OUT_START'];
				var perc:Number = 1-(framesPlayed/(_labels_obj['ROLL_OUT']-_labels_obj['ROLL_OUT_START']));
				shift = MathUtils.limit(Math.round(perc*(_labels_obj['ROLL_OVER']-_labels_obj['ROLL_OVER_START'])), 0, _labels_obj['ROLL_OVER']-_labels_obj['ROLL_OVER_START']);
			}
			_mc.gotoAndPlay(_labels_obj['ROLL_OVER_START']+shift);
		}
		
		private function _onMouseRollOut_handler($evt:MouseEvent):void{
			if(_curState == AnimationState.ROLL_OVER_START || _curState == AnimationState.ROLL_OVER){
				var shift:int = 0;
				if( mirrorOverOutAnimations && _curState == AnimationState.ROLL_OVER_START){
					var framesPlayed:int = _mc.currentFrame - _labels_obj['ROLL_OVER_START'];
					var perc:Number = 1-(framesPlayed/(_labels_obj['ROLL_OVER']-_labels_obj['ROLL_OVER_START']));
					shift = MathUtils.limit(Math.round(perc*(_labels_obj['ROLL_OUT']-_labels_obj['ROLL_OUT_START'])), 0, _labels_obj['ROLL_OUT']-_labels_obj['ROLL_OUT_START']);
				}
				_mc.gotoAndPlay(_labels_obj['ROLL_OUT_START']+shift);
			}
		}
		
		private function _onMouseClick_handler($evt:MouseEvent):void{
			_mc.gotoAndPlay('CLICK_START');
		}
		
		private function _onMouseUp_handler($evt:MouseEvent):void{
			_mc.gotoAndPlay('MOUSE_UP_START');
		}
		
		private function _onMouseDown_handler($evt:MouseEvent):void{
			_mc.gotoAndPlay('MOUSE_DOWN_START');
		}
		
	}
}