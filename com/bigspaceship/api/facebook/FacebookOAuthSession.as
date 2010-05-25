/**
 * FacebookAuthManager by Big Spaceship. 2010
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
package com.bigspaceship.api.facebook
{
	/**
	 * FacebookAuthManager
	 *
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Jamie Kosoy
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */	
	public class FacebookOAuthSession
	{
		private var _api_key		:String;
		private var _access_token	:String;
		private var _expires		:Number;
		private var _secret			:String;
		private var _session_key	:String;
		private var _sig			:String;
		private var _uid			:String;
		
		private var _perms			:Array;
		
		public function FacebookOAuthSession($api_key:String,$sessionData:Object,$perms:String) {
			_api_key = $api_key;
			_access_token = $sessionData.access_token;
			_expires = $sessionData.expires; 
			_secret = $sessionData.secret;
			_session_key = $sessionData.session_key;
			_sig = $sessionData.sig;
			_uid = $sessionData.uid;
			
			_perms = $perms.split(",");
		}
		
		public function get api_key():String { return _api_key; }
		public function get access_token():String { return _access_token; }
		public function get expires():Number { return _expires; }
		public function get secret():String { return _secret; }
		public function get session_key():String { return _session_key; }
		public function get sig():String { return _sig; }
		public function get uid():String { return _uid; }
		
		public function hasPermission($permission:String):Boolean { return _perms.indexOf($permission) > -1; }
	
	}
}