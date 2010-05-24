/**
 * Semaphore by Big Spaceship. 2008-2009
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2008-2009 Big Spaceship, LLC
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

package com.bigspaceship.utils 
{
	import com.bigspaceship.events.SemaphoreEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * Semaphore
	 *
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class Semaphore extends EventDispatcher {
		
		private var _id          : String;
		private var _locks       : Dictionary;
		private var _numlocks    : Number = 0;
		private var _numunlocked : Number = 0;
		
		public function get isLocked():Boolean {
	    	var v:Boolean;
	    	for each(v in _locks) {
	    		if(v) {
	    			// If there is an open lock, isLocked = false;
	    			return false;
	    		}
	    	}
	    	return true;
	    }
	    
	    public function get isUnlocked():Boolean {
	        // If every stored condition has been marked "true", then
	        // returns true
	        var v:Boolean;
	        for each(v in _locks) {
	        	if(!v) {
	        		return false;
	        	}
	        }
	        return true;
	    }
	    
		public function get countLocked():Number {
			return _numlocks - _numunlocked;
		}
	    
		public function get countUnlocked():Number {
			return _numunlocked;
		}
		
		public function get countLocks():Number {
			return _numlocks;
		}
		
		

		public function Semaphore($id:String, $locks:Array = null):void {
			var l:Array  = $locks ? $locks : new Array();
			var i:Number = l.length;
			
			_id    = ($id ? $id : Math.round(Math.random() * 100000)).toString();
			_locks = new Dictionary(true);
			
			if(i) while(i--) addLock(l[i]);
		}
		
		
		public function openLock($l:String):Boolean {
			_locks[$l] = true;
			_numunlocked++;
			
			if(isUnlocked) {
	            // Fires an onUnlock event the very moment the final
	            // condition has been met.  You can either subscribe 
	            // to this event or test the returned value.
				dispatchEvent(new SemaphoreEvent(SemaphoreEvent.UNLOCK, _id));	
				
				return true;
				
			} else {
				return false;
				
			}
		}
		
			
	    public function resetLocks():void {
	        // Intended to be called prior to reuse of a semaphore instance.
	        var l:String;
	        
	        for(l in _locks) _locks[l] = false;
	        
	        _numunlocked = 0;
	    }
		
		// WARNING: Functionality you should think twice about using, because
		// it may result in serious logic issues if you're not careful.  A
		// semaphore should be filled with a static number of locks and not
		// modified afterwards.  Locks can be opened, but all locks should be
		// reset simultaneously.  
		public function addLock($l:String):void {
			_numlocks++;
			_locks[$l] = false;
		}
		
		public function removeLock($l:String):void {
	        // I'm not sure if it's a good idea to remove locks
	        // but I guess I'll leave in the ability to do it.
	        _numlocks--;    
			delete _locks[$l];
		}
		
		public function closeLock($l:String):void {
	        // I'm not sure if it's a good idea to re-close locks either,
	        // but I guess I'll leave in the ability to do it.  Just don't
	        // do it often.
			_locks[$l] = false;	
			_numunlocked--;
		}
	}
}