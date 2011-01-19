/**
 * SimpleSequencer by Big Spaceship. 2008-2011
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2008-2011 Big Spaceship, LLC
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
	
	import flash.display.MovieClip;
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
	 * Dispatched when a sequence deactivates but it is not complete yet e.g. when currently running step is complete after pause() is called. 
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="deactivate", type="flash.events.Event")]
	
	/**
	 * SimpleSequencer
	 *
	 * @copyright 		2008-2011 Big Spaceship, LLC
	 * @author			Daniel Scheibel, Stephen Koch
	 * @version			2.0 
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
		
		private var _sprite:MovieClip = new MovieClip();
		
		private var _isPaused:Boolean = false;
		private var _isActive:Boolean = false;
		
		
		public function get id():String{
			return _id;
		}
		public function set id($value:String):void{
			return _id = $value;
		}
		public function get isActive():Boolean{
			return _isActive;
		}
		public function get isPaused():Boolean{
			return _isPaused;
		}
		
		/**
		 * The <code>SimpleSequencer</code> constructor
		 * 
		 * @param $id				A String that helps to identify the sequence while debugging.
		 * 
		 */
		public function SimpleSequencer($id:String=''){
			//creating an "unique" id for output-debugging reasons
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
			var anim:Object = {stepId:$stepId, type:'normal', target:$target, functionToCall:$functionToCall, eventToListen:$eventToListen, args:$args};
			_addStep(anim);
		}
		/**
		 * The <code>addASynchStep</code> method
		 * 
		 * @param $stepId			Number
		 * @param $target			EventDispatcher
		 * @param $functionToCall	Function
		 * @param $eventToListen	String
		 * @param $args				Object
		 * 
		 */		
		public function addASynchStep($stepId:Number, $functionToCall:Function, $args:Object=null):void{
			var anim:Object = {stepId:$stepId, type:'asynch', functionToCall:$functionToCall, args:$args};
			_addStep(anim);
		}
		
		/**
		 * The <code>pause</code> method deactivates the sequence after the currently processed step.
		 * 
		 */		
		public function pause():void{
			_isPaused = true;
		}
		
		/**
		 * The <code>start</code> method starts the Sequence if it's not active already and sets isPaused flag to false.   
		 * 
		 * @param $reset			A Boolean value that determines if sequence starts from the beginning or resumes were left of after being paused.
		 * 							If true the next step will be the first step in the sequence. 							
		 * 
		 */	
		public function start($reset:Boolean = false):void{
			_isPaused = false;
			if($reset)_countStep = 0;
			if(!_isActive)_next();
		}
		
		
		
		private function _addStep($anim_obj:Object):void{
			var stepExists:Boolean = false;
			for(var i:int=0; i<_animationSteps_array.length; i++){
				if(_animationSteps_array[i].stepId == $anim_obj.stepId){
					_animationSteps_array[i].array.push($anim_obj);
					stepExists = true;
				}
			}
			if(!stepExists){
				_animationSteps_array.push({stepId:$anim_obj.stepId, array:new Array($anim_obj)});
			}
		}
			
		private function _next():void{
			_isActive = true;
			if(_animationSteps_array.length > 0){
				//ds: sort array by stepId:
				_animationSteps_array.sortOn('stepId', Array.NUMERIC);

				if(debug) Out.debug(this, 'START: '+_id+', steps: '+_animationSteps_array.length+', _countStep: '+_countStep+', stepId: '+_animationSteps_array[_countStep].stepId );

				_parallelActions_array = new Array();
				var i:int;
				var animObj:Object;
				//ds: addEventlisteners
				var len:uint = _animationSteps_array[_countStep].array.length;
				for(i = 0; i < len; i++){
					animObj = _animationSteps_array[_countStep].array[i];
					switch(animObj.type){
						case 'normal':
							animObj.target.addEventListener(animObj.eventToListen, _onAnimationComplete);
							break;
						case 'asynch':
							break;
					}
					newSemLockId();
				}
				//ds: call methods
				for(i = 0; i < len; i++){
					//if(debug) Out.status(this, "i: " + i);
					animObj = _animationSteps_array[_countStep].array[i];
					switch (animObj.type){
						case 'normal':
						case 'asynch':
							if(animObj.args && animObj.args.hasOwnProperty('delay')){
								if(debug) Out.status(this, "delay: " + animObj.args.delay + ", _id = " + _id);
								var timer:Timer = new Timer(animObj.args.delay, 1);
								timer.addEventListener(TimerEvent.TIMER, _onTimerEvent_handler);
								_timer_dic[timer] = animObj;
								timer.start();
							}else{
								//if(debug) Out.debug(this, "_id = " + _id + ", animObj = " + animObj);
 								if(animObj.args && animObj.args.hasOwnProperty('functionToCallParams')){
									animObj.functionToCall.apply(null, animObj.args.functionToCallParams);
								}else{
									animObj.functionToCall();
								}
								if(animObj.type == 'asynch')_onAnimationComplete();
							}
							break;
					}
				}
			}else{
				_onComplete();
				if(debug){
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
			if(_timer_dic[$evt.target].type == 'asynch')_onAnimationComplete();
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
		
		private function _onAnimationComplete($evt:Event=null):void{
			if(debug){
				Out.debug(this, '_onAnimationComplete: '+ (($evt)?$evt.target:'aSynch call complete')+', _id: '+ _id);
			}
			if($evt)$evt.target.removeEventListener($evt.type, _onAnimationComplete);
			_parallelActions_array.pop();
			_checkSemaphores();
		}
		
		private function _checkSemaphores():void{
			if(_parallelActions_array.length < 1){
				if(_countStep+1<_animationSteps_array.length){
					_countStep+=1;
					//start next step
					if(_isPaused){
						//animation cancelled/paused
						_onPause();
					}else{
						_next();
					}
				}else{
					//all animations complete
					_onComplete();
				}
			}
		}
		
		private function _onComplete():void{
			_isActive = false;
			_isPaused = false;
			_countStep = 0;
			if(debug){Out.debug(this, 'COMPLETE id: '+ _id);}
			_sprite.removeEventListener(Event.ENTER_FRAME, _onEnterFrame_handler);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function _onPause():void{
			_isActive = false;
			if(debug)Out.debug(this, 'PAUSED and DEACTIVE id: '+ _id);
			_sprite.removeEventListener(Event.ENTER_FRAME, _onEnterFrame_handler);
			dispatchEvent(new Event(Event.DEACTIVATE));
		}
	}
}