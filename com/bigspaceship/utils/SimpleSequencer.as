/**
 * SimpleSequencer by Big Spaceship. 2008-2010
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
package com.bigspaceship.utils{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * Dispatched when a sequence ends.
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * SimpleSequencer
	 *
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Daniel Scheibel, Stephen Koch
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class SimpleSequencer extends EventDispatcher{
		
		public var debug:Boolean = false; 
		
		private var _animationSteps_array:Array = new Array();
		private var _countStep:int;
		
		private var _id:String;
				
		private var _parallelActions_array:Array;
		private var _timer_dic:Dictionary = new Dictionary();
		
		private var _sprite:Sprite = new Sprite();
		
		public function SimpleSequencer($id:String){
			//creating an "unique" id for debugging reasons
			_id = $id +'_'+ int(Math.random()*100);
			
			if(debug){
				Out.debug(this, 'SimpleSequencer CONSTRUCTOR called, id:' +  _id);
				
				_sprite.addEventListener(Event.ENTER_FRAME, _onEnterFrame_handler);
			}
		}
		
		/**
		 * The <code>traceSteps</code> method
		 * 
		 */		
		public function traceSteps():void{
			for(var i:int=0; i<_animationSteps_array.length; i++){
				Out.debug(this, 'SimpleSequencer step: '+ _animationSteps_array[i].stepId+', '+_animationSteps_array[i].array);
			}
		}
		
		/**
		 * The <code>addStep</code> method
		 * 
		 * @param $stepId			Number
		 * @param $target			EventDispatcher
		 * @param $functionToCall	Function
		 * @param $eventToListen	String
		 * @param $args				Object
		 * 
		 */		
		public function addStep($stepId:Number, $target:EventDispatcher, $functionToCall:Function, $eventToListen:String, $args:Object=null):void{
			var anim:Object = {type:'normal', target:$target, functionToCall:$functionToCall, eventToListen:$eventToListen, args:$args};
			
			var stepExists:Boolean = false;
			for(var i:int=0; i<_animationSteps_array.length; i++){
				if(_animationSteps_array[i].stepId == $stepId){
					_animationSteps_array[i].array.push(anim);
					stepExists = true;
				}
			}
			if(!stepExists){
				_animationSteps_array.push({stepId:$stepId, array:new Array(anim)});
			}
		}
		
		/**
		 * The <code>start</code> method starts the Sequence
		 * 
		 */		
		public function start():void{
			if(_animationSteps_array.length > 0){
				//sort array by stepId:
				_animationSteps_array.sortOn('stepId', Array.NUMERIC);

				if(debug) Out.debug(this, 'START: '+_id+', steps: '+_animationSteps_array.length+', _countStep: '+_countStep+', stepId: '+_animationSteps_array[_countStep].stepId );

				_parallelActions_array = new Array();
				var i:int;
				var animObj:Object;
				//addEventlisteners
				var len:uint = _animationSteps_array[_countStep].array.length;

				for(i = 0; i < len; i++)
				{
					animObj = _animationSteps_array[_countStep].array[i];
					switch(animObj.type)
					{
						case 'normal':
							animObj.target.addEventListener(animObj.eventToListen, _onAnimationComplete);
							break;
						/* case 'bigTweenLite':
							break; */
					}
					newSemLockId();
				}

				for(i = 0; i < len; i++)
				{
					if(debug) Out.status(this, "i: " + i);
					animObj = _animationSteps_array[_countStep].array[i];
					switch (animObj.type)
					{
						case 'normal':
							if(animObj.args && animObj.args.hasOwnProperty('delay'))
							{
								if(debug) Out.status(this, "delay: " + animObj.args.delay + ", _id = " + _id);

								var timer:Timer = new Timer(animObj.args.delay, 1);
								timer.addEventListener(TimerEvent.TIMER, _onTimerEvent_handler);
								_timer_dic[timer] = animObj;
								timer.start();
							}else
							{
								if(debug) Out.debug(this, "_id = " + _id + ", animObj = " + animObj);
								
 								if(animObj.args && animObj.args.hasOwnProperty('functionToCallParams'))
								{
									animObj.functionToCall.apply(null, animObj.args.functionToCallParams);
								}else
								{
									animObj.functionToCall();
								} 
							}
							break;
					}
				}
			}else
			{
				_onComplete();
				if(debug)
				{
					Out.debug(this, 'no steps added!');
				}
			}
		}
		
		private function _onTimerEvent_handler($evt:Event):void{
			if(debug){
				Out.debug(this, "ID = " + _id + ' :: _onTimerEvent_handler, target: '+_timer_dic[$evt.target].target);
			}
			if(_timer_dic[$evt.target].args && _timer_dic[$evt.target].args.hasOwnProperty('functionToCallParams')){
				_timer_dic[$evt.target].functionToCall.apply(null, _timer_dic[$evt.target].args.functionToCallParams);
			}else{
				_timer_dic[$evt.target].functionToCall();
			}
			$evt.target.removeEventListener($evt.type, _onTimerEvent_handler);
			delete _timer_dic[$evt.target];
		}
		
		private function newSemLockId():String{
			var lock:String;
			//do.. while loop to prevent double lockIds.
			do{ 
				lock = String(Math.random());
			}
			while(_parallelActions_array.indexOf(lock)>-1);
			_parallelActions_array.push(lock);
			if(debug){
				Out.debug(this, 'newLockId: '+ lock+', countLocks: '+ _parallelActions_array.length);
			}
			return lock;
		}
		
		private function _onEnterFrame_handler($evt:Event):void{
			//ds: this method is for debug purposes only
			Out.debug(this, 'sequence running: '+ _id + ', steps: '+ _animationSteps_array.length+', _countStep: '+ _countStep+ ', stepId: '+ _animationSteps_array[_countStep].stepId);
		}
		
		private function _onAnimationComplete($evt:Event):void{
			if(debug){
				Out.debug(this, '_onAnimationComplete: '+ $evt.target+', _id: '+ _id);
			}
			$evt.target.removeEventListener($evt.type, _onAnimationComplete);
			_parallelActions_array.pop();
			_checkSemaphores();
		}
		
		private function _checkSemaphores():void{
			if(_parallelActions_array.length < 1){
				if(_countStep+1<_animationSteps_array.length){
					_countStep+=1;
					//start next step
					start();
				}else{
					//all animations complete
					_onComplete();
				}
			}
		}
		
		private function _onComplete():void{
			if(debug){
				Out.debug(this, 'COMPLETE id: '+ _id);
			}
			_sprite.removeEventListener(Event.ENTER_FRAME, _onEnterFrame_handler);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}