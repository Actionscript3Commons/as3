/**
 * StandardSlider by Big Spaceship. 2009
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
	import com.bigspaceship.events.SliderEvent;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.Standard;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * The <code>StandardSlider()</code> Class handles scrolling functionality
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0.0
	 * 
	 * @version		1.0
	 * 
	 * @author Stephen Koch, Jamie Kosoy, Daniel Scheibel
	 * @since  03.11.2009
	 */
	public class StandardSlider extends Standard
	{
		//--------------------------------------
		// PRIVATE & PROTECTED VARIABLES
		//--------------------------------------
		
		private var _lastTarget		: MovieClip;
		private var _dist			: int = 3;
		
		protected var _trough		: MovieClip;
		protected var _isDragging	: Boolean;
		protected var _isHorizontal	: Boolean;
		protected var _offset		: int;
		protected var _dragger 		: StandardButton;
		protected var _up 			: StandardButton;
		protected var _down			: StandardButton;
		
		//--------------------------------------
		//  CLASS CONSTANTS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * @constructor
		 */
		public function StandardSlider($mc:MovieClip, $isHorizontal:Boolean = false, $buttonsOnly:Boolean = false)
		{
			super($mc);
			
			_dragger = new StandardButton(_mc.dragger_mc);
			_dragger.btn.addEventListener(MouseEvent.MOUSE_DOWN,_draggerOnMouseDown,false,0,true);
			_trough = _mc.trough_mc;
			_dragger.mc.visible = _trough.visible = !$buttonsOnly;
			
			_isDragging = false;
			_isHorizontal = $isHorizontal;
			
			if(_mc.up_mc && _mc.down_mc)
			{
				_up = new StandardButton(_mc.up_mc);
				_down = new StandardButton(_mc.down_mc);
				_lastTarget = _up.mc;

				_up.btn.addEventListener(MouseEvent.MOUSE_DOWN, _scroll, false, 0, true);
				_down.btn.addEventListener(MouseEvent.MOUSE_DOWN, _scroll, false, 0, true);
			}
		};

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function reset():void
		{
			if(_up && _down) _lastTarget = _up.mc;
			_isHorizontal ? _dragger.mc.x = 0 : _dragger.mc.y = 0;
			_draggerOnMouseUp();
			_update();
		};
		
		
		public function setPos($n:Number):void
		{
			if(_isHorizontal) _dragger.mc.x = ((_trough.width - _offset) - _dragger.mc.width) * $n;
			else _dragger.mc.y = ((_trough.height - _offset) - _dragger.mc.height) * $n;
			_update();
		};
		
		
		public function getPos():Number
		{
			var cur:Number = _isHorizontal ? _dragger.mc.x : _dragger.mc.y;
			var tot:Number = _isHorizontal ? (_trough.width - _dragger.mc.width) : (_trough.height - _dragger.mc.height);		
			var p:Number = cur/tot;
						
			return p;
		};
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// sk: scrolling via up/down buttons
		private function _scroll($evt:MouseEvent):void
		{
			if($evt.target.parent != _lastTarget)
			{
				_dist *= -1;
				_lastTarget = $evt.target.parent;
			}
			_mc.addEventListener(Event.ENTER_FRAME, _updateScroll, false, 0, true);
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false, 0, true);
		};
		
		
		// sk: up/down buttons handler
		private function _onMouseUp($evt:MouseEvent = null):void
		{
			_mc.removeEventListener(Event.ENTER_FRAME, _updateScroll);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		};
		
		
		// sk: updated the dragger via up/down, then do the _update 
		private function _updateScroll($evt:Event = null):void
		{
			if(_isHorizontal)
			{
				_dragger.mc.x -= _dist;
				if(_dragger.mc.x >= _trough.width - _dragger.mc.width) _dragger.mc.x = _trough.width - _dragger.mc.width;
				if(_dragger.mc.x <= 0) _dragger.mc.x = 0;
			}else
			{
				_dragger.mc.y -= _dist;
				if(_dragger.mc.y >= _trough.height - _dragger.mc.height) _dragger.mc.y = _trough.height - _dragger.mc.height;
				if(_dragger.mc.y <= 0) _dragger.mc.y = 0;
			}
			_update($evt);
		};
		
		
		private function _draggerOnMouseDown($evt:MouseEvent):void
		{
			_isDragging = true;
			dispatchEvent(new SliderEvent(SliderEvent.START,_getPercentageDragged()));

			var r:Rectangle;
			if(_isHorizontal) r = new Rectangle(0,0,(_trough.width - _offset) - _dragger.mc.width,0);
			else r = new Rectangle(0,0,0,(_trough.height - _offset) - _dragger.mc.height);
			_dragger.mc.startDrag(false,r);

			_mc.addEventListener(Event.ENTER_FRAME,_update,false,0,true);
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP,_draggerOnMouseUp,false,0,true);
		};
		
		
		private function _draggerOnMouseUp($evt:MouseEvent = null):void
		{
			_isDragging = false;
			_dragger.mc.stopDrag();
			_mc.removeEventListener(Event.ENTER_FRAME,_update);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,_draggerOnMouseUp);
			dispatchEvent(new SliderEvent(SliderEvent.COMPLETE,_getPercentageDragged()));
		};
		
		
		protected function _update($evt:Event = null):void { dispatchEvent(new SliderEvent(SliderEvent.UPDATE,_getPercentageDragged())); };
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------

		private function _getPercentageDragged():Number
		{
			var cur:Number = _isHorizontal ? _dragger.mc.x : _dragger.mc.y;
			var tot:Number = _isHorizontal ? ((_trough.width - _offset) - _dragger.mc.width) : ((_trough.height - _offset) - _dragger.mc.height);
			
			return cur/tot;	
		};
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get visible():Boolean { return _dragger.mc.visible; };
		public function set visible($isVisible:Boolean):void { _dragger.mc.visible = $isVisible; };
		public function get isDragging():Boolean { return _isDragging; };
		public function set scrollAmount($value:int):void { _dist = $value; };
		/**
		*  The <code>offset()</code> method sets the offset, if any,
		*	for the gutter left/right or top/bottom
		*
		*	@param offset Specifies the offset
		*/
		public function set offset($value:int):void { _offset = $value; };
	};
};

