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
	import flash.external.ExternalInterface;
	import flash.events.EventDispatcher;

	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.events.FacebookAuthEvent;
	
	
	public class OAuthBridge extends EventDispatcher
	{
		private var _session		:OAuthSession;
		private var _debugSession	:OAuthSession;
		
		public function OAuthBridge($debugSession:OAuthSession = null) {
			if(Environment.IS_IN_BROWSER) {
				ExternalInterface.addCallback("handleFacebookLogin",_loginHandler);
				ExternalInterface.addCallback("handleFacebookLogout",_logoutHandler);
				ExternalInterface.addCallback("handleFacebookLoginCancel",_loginCancelHandler);
			}
			else {
				Out.warning(this,"ExternalInterface isn't available. Will use debug session instead if passed in..."); 
				_debugSession = $debugSession;
			}
		}
		
		public function get session():OAuthSession { return _session; }
		
		public function initialize():void {
			if(Environment.IS_IN_BROWSER){
				ExternalInterface.call("com.bigspaceship.api.facebook.OAuthBridge.initialize");		
			}
			else {
				_logoutHandler();
			}
		}

		// login
		// jk: options should follow Facebook's documentation:
		// jk: ex: { perms:"publish_stream"}
		public function login($options:Object = null):void {
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_START));
			if(Environment.IS_IN_BROWSER) ExternalInterface.call("com.bigspaceship.api.facebook.OAuthBridge.login",$options);
			else {
				_session = _debugSession;
				dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN));
				dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));			
			}
		}
		
		private function _loginHandler($api_key:String,$session:Object,$perms:String = ""):void {
			_session = new OAuthSession($api_key,$session,$perms);
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN));
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));
		}
		
		private function _loginCancelHandler():void {
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));			
		}

		// logout
		public function logout():void { 
			if(Environment.IS_IN_BROWSER) ExternalInterface.call("com.bigspaceship.api.facebook.OAuthBridge.logout");
			else _logoutHandler();
		}
		
		private function _logoutHandler():void {
			_session = null;
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGOUT));			
		}
		
	}
}