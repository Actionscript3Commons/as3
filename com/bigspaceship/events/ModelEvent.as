/**
 * ModelEvent by Big Spaceship. 2010
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
package com.bigspaceship.events {	
	
	import flash.events.Event;
	
	/**
	 *  The <code>ModelEvent</code> Class describes all Events dispatched from Model<br />
	 *  This is more a Template as a usable class. Please copy base structure into project specific package.
	 *
	 *  @param			$type: (String) Which event to dispatch.
	 *  @param			$data: (Object) Information to pass.
	 *  @param			$bubbles: (Boolean) Indicates whether an event is a bubbling event.
	 *  @param			$cancelable: (Boolean) Indicates whether the behavior associated with the event can be prevented.
	 * 
	 *  @copyright 		2009 Big Spaceship, LLC
	 *  @author			Daniel Scheibel
	 *  @version		1.0
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9.0.0
	 */
	public class ModelEvent extends Event{
		
		private var _data:Object;
		
		public static const LOAD_PROCESS:String = "loadProcess";
		public static const SCREEN_NEXT:String = "nextScreen";
		public static const SCREEN_CUR:String = "currentScreen";
		public static const SCREEN_LAST:String = "previousScreen";
		
		public static const SITE_TITLE:String = "siteTitle";
		
		
		public function get data():Object{
			return this._data;
		}
		
		//-----------------------------------------------------------------------------
		// Constructor functions:
		//-----------------------------------------------------------------------------
		public function ModelEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false):void{
			super($type, $bubbles, $cancelable);
			this._data = $data;
		}
		
	}
}