/**
 * AIRProxy by Big Spaceship. 2007
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2007 Big Spaceship, LLC
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
package com.bigspaceship.air
{
	import flash.net.URLRequest;

	import flash.display.Loader;
	import flash.display.MovieClip;
	
	/**
	 * AIRProxy is the Document Root class of proxy.fla. 
	 * This will circumvent the need to keep all of our FLAs in the _deploy directory, which will be really messy.
	 * 
	 *
	 * @copyright 		2007 Big Spaceship, LLC
	 * @author			Jamie Kosoy
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.41
	 *
	 */

	public class AIRProxy extends MovieClip
	{
		private static var __instance		:AIRProxy;
		
		public function AIRProxy()
		{
			var l:Loader = new Loader();
			addChild(l);
			l.load(new URLRequest("main.swf"));
			__instance = this;
		};
		
		public static function getInstance():AIRProxy { return __instance; };
	};
}
