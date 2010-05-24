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
	import com.bigspaceship.events.FacebookAuthEvent;
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	import com.facebook.Facebook;
	import com.facebook.commands.users.GetLoggedInUser;
	import com.facebook.events.FacebookEvent;
	import com.facebook.session.IFacebookSession;
	import com.facebook.session.JSSession;
	import com.facebook.session.WebSession;
	import com.facebook.utils.FacebookConnectUtil;
	
	import flash.net.LocalConnection;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	/**
	 * FacebookAuthManager
	 *
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Brian Steegall, Jamie Kosoy, Stephen Koch
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */	
	public class FacebookAuthManager extends EventDispatcher
	{
		private var _environment	: String;
		private var _api			: Facebook;
		private var _uid			: String;
		private var _session		: IFacebookSession;
		private var _connectutil	: FacebookConnectUtil;
		private var _swfId			: String;
		private var _loaderInfo		: LoaderInfo;
		
		public function FacebookAuthManager()
		{
			super();
			_api = new Facebook();
		}
		
		private function _getFlashVar($id:String):String {
			if(_loaderInfo.parameters[$id] && _loaderInfo.parameters[$id] != "") return _loaderInfo.parameters[$id];
			return null;
		}
		
		
		//sk: initiates the AUTH PAGE in the same window (credit to Josh)
		public function authorizeApp($perms:Array = null):void
		{
			if(_environment == FacebookEnvironment.ON_FB_NOT_AUTHORIZED)
			{
				var url:String = "https://graph.facebook.com/oauth/authorize?client_id=" + _getFlashVar("fb_sig_app_id") + "&redirect_uri=" + _getFlashVar("redirect_uri");
				var i:uint = $perms.length;
				if(i)
				{
					// sk: if we have some extended permissions, add them
					url += "&scope=";
					while(i--)
					{
						url += $perms[i] + ",";
					}
					// sk: remove last comma
					url = url.slice(0, -1);
				}
				openURL(url);
			}
		};
		
		
		// sk: be sure to include the necessary FBML bridge in your index page
		public function openURL($url:String):void
		{
			if(bOnFacebook)
			{
				var _localConn:LocalConnection = new LocalConnection();
				_localConn.send(_getFlashVar("fb_local_connection"), "callFBJS", "document.setLocation", [$url]);
			}
		};
		
		/*******************************************/
		// initialize
		/*******************************************/
		// jk: Facebook automatically passes a parameter named fb_sig_api_key with your API key as a flashvar.
		// jk: I recommend your FBConnect-enabled site does the same, as you could feasibly build for both places at the same time.
		public function initialize($loaderInfo:LoaderInfo,$swfId:String = null,$apiKey:String = null):void{
			_loaderInfo = $loaderInfo;
			_swfId = $swfId ? $swfId : _getFlashVar('as_swf_name');					
						
			var apiKey:String = $apiKey ? $apiKey : _getFlashVar("fb_sig_api_key");
			
			// jk: the user is on facebook and they have authorized the app
			if(_getFlashVar('fb_sig_added') == '1') {
				_environment = FacebookEnvironment.ON_FB_AUTHORIZED;
				_session = new WebSession(apiKey,_getFlashVar('fb_sig_ss'),_getFlashVar('fb_sig_session_key'));
			}
			// jk: the user is on facebook but they aren't authorized with the app. let's learn more...
			else if(_getFlashVar('fb_sig_added') == '0') {

				// jk: they user is not logged in at all.
				if(_getFlashVar('fb_sig_logged_out_facebook') == '1') {
					_environment = FacebookEnvironment.ON_FB_NOT_LOGGED_IN;
					Out.fatal(this,"The user is accessing this through Facebook but is not logged in. Cannot continue.");
				}
				// jk: the user is logged in but they have not authorized the app. we need a WebSession to do anything.
				else {
					_environment = FacebookEnvironment.ON_FB_NOT_AUTHORIZED;
					_session = new WebSession(apiKey,_getFlashVar('fb_sig_ss'));
				}				
			}
			// jk: the user is not even on facebook. Facebook Connect will be used.
			else {
				_environment = FacebookEnvironment.CONNECT;
				_session = new JSSession(apiKey,_swfId);

				if(ExternalInterface.available) {
					ExternalInterface.addCallback("onFacebookLogin", _javascript_onFacebookLogin_handler);
					ExternalInterface.addCallback("onFacebookLoginCancel", _javascript_onFacebookCancel_handler);
					_connectutil = new FacebookConnectUtil(_loaderInfo);
				}
				else Out.warning(this,"FacebookConnectUtil cannot work outside the browser.");
			}
			
			Out.info(this,"Environment Type: " + _environment);

			if(_session) {
				_session.addEventListener(FacebookEvent.CONNECT, _sessionVerified_handler, false, 0, true);	
				// jk: TO DO: add additional events for when session verification fails.
				_api.startSession(_session);				
				// jk: if we're not using facebook connect, why not just go straight to logging in?
				if(_environment != FacebookEnvironment.CONNECT && Environment.IS_IN_BROWSER) login();
				else if( ! Environment.IS_IN_BROWSER)
				{
					// sk: not in browser? let's keep things moving ( in the case where the app doesn't /need/ FB to run )
					_sessionOnVerified();
				}
			}

		}

		/*******************************************/
		// logging in
		/*******************************************/
		public function login():void{
			Out.status(this,"login();");
			
			if(!bLoggedIn) {
				if(_session) {
					dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_START));
	
					// jk: there's an extra step with facebook connect. first we have to ask JavaScript to log us in.
					// jk: once that's done, JavaScript will send over the session and secret data that came along with an authenticated user, at which point we can verify that session is valid.						
					if(_environment == FacebookEnvironment.CONNECT) {
						if(ExternalInterface.available) {
							var isReady:Boolean = ExternalInterface.call("fbconnect.isReady");
							Out.debug(this,"" + isReady);
							if(isReady) ExternalInterface.call("fbconnect.login");
							else Out.fatal(this, "An error occurred connecting with JavaScript. Maybe you don't have the JavaScript file on your HTML?");
						}
						else {
							if(Environment.IS_IN_BROWSER) Out.warning(this,"ExternalInterface isn't available.");				
							else {
								Out.info(this,"Not in the browser, faking session verification for testing purposes. Note that no API calls will actually work.");
								_sessionOnVerified();						
							}
						}
					}
					else {
						_session.verifySession();	
					}
				}
			}
			else {
				_sessionOnVerified();
			}
		}

		private function _javascript_onFacebookLogin_handler():void{ _session.verifySession(); }

		private function _javascript_onFacebookCancel_handler():void {
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_CANCEL));
		}

		private function _sessionVerified_handler($evt:FacebookEvent):void { _sessionOnVerified(); }
		private function _sessionOnVerified():void {
			Out.status(this,"_sessionOnVerified();");
			
			// jk: if we're using Facebook Connect cache the uid so we don't keep asking javascript for it.
			if(_environment == FacebookEnvironment.CONNECT) {
				_uid = _connectutil.getLoggedInUser();
				//_loginComplete();
			}
			else if(_environment == FacebookEnvironment.ON_FB_AUTHORIZED) {
				_uid = _getFlashVar("fb_sig_user");
				//_loginComplete();
			}
			// sk: I want to know that we have completed the cycle regardless of _environment
			_loginComplete();
		}
		
		private function _getLoggedInUser_handler($evt:FacebookEvent):void {
			$evt.target.removeEventListener(FacebookEvent.COMPLETE,_getLoggedInUser_handler);

			var result:XML = XML($evt.data.rawResult);
			_uid = result.toString();
			_loginComplete();
		}
		
		private function _loginComplete():void {
			Out.status(this, "_loginComplete");
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN));
		}

		/*******************************************/
		// logout 
		/*******************************************/
		public function logout():void{
			if(bLoggedIn) {
				_uid = null;
				_api.logout();

				if(ExternalInterface.available) ExternalInterface.call("fbconnect.logout");
			}

			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGOUT));
		}
		
		/*******************************************/
		// getters
		/*******************************************/
		public function get uid():String { 
			if(_uid) return _uid;	
			else if(_session.uid) return _session.uid;
			else return null;
		}

		public function get api():Facebook{ return _api; }
		public function get bLoggedIn():Boolean{ return uid != null; }
		public function get environment():String { return _environment; }
		public function get bOnFacebook():Boolean { return _environment == FacebookEnvironment.ON_FB_AUTHORIZED || _environment == FacebookEnvironment.ON_FB_NOT_AUTHORIZED || _environment == FacebookEnvironment.ON_FB_NOT_LOGGED_IN; }
		
		
		/*******************************************/
		// cleanup
		/*******************************************/
		public function destroy():void{
			logout();
			_session = null;
			_api = null;
		}
	}
}