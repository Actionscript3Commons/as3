/**
 * OAuthBridge by Big Spaceship. 2010
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
	 * OAuthBridge
	 *
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Jamie Kosoy, Stephen Koch
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */	
	import flash.external.ExternalInterface;
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.display.LoaderInfo;

	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.events.FacebookAuthEvent;
	
	import com.adobe.serialization.json.JSON;
	
	public class OAuthBridge extends EventDispatcher
	{
		private var _session		:OAuthSession;
		private var _perms			:OAuthPerms;
		private var _debugSession	:OAuthSession;
		private var _loaderInfo		: LoaderInfo;
		
		public var apiSecuredPath	: String = "https://graph.facebook.com";
        public var apiUnsecuredPath	: String = "http://graph.facebook.com";
        public var useSecuredPath	: Boolean = true;
		
		public function OAuthBridge($debugSession:OAuthSession = null) {
			if( Environment.IS_IN_BROWSER && ExternalInterface.available ) {
				try
				{
					ExternalInterface.addCallback("handleFacebookLogin",_loginHandler);
					ExternalInterface.addCallback("handleFacebookLogout",_logoutHandler);
					ExternalInterface.addCallback("handleFacebookLoginCancel",_loginCancelHandler);					
				}catch( $e:Error ) { Out.debug( this, 'error: ' + $e ); }
			}
			else {
				Out.warning(this,"ExternalInterface isn't available. Will use debug session instead if passed in..."); 
				_debugSession = $debugSession;
			}
		}
		
		public function get session():OAuthSession { return _session; }
		
		public function hasPermission( $permission:String ):Boolean { return _perms.hasPermission( $permission ); };

		public function initialize( $loaderInfo:LoaderInfo ):void {
			
			_loaderInfo = $loaderInfo;

			if( _loaderInfo.parameters.session )
			{
				_session = new OAuthSession( JSON.decode( _loaderInfo.parameters.session ) );
				dispatchEvent( new FacebookAuthEvent( FacebookAuthEvent.LOGIN ) );
				return;
			}
			
			if( Environment.IS_IN_BROWSER && ExternalInterface.available )
			{
				try
				{
					ExternalInterface.call("com.bigspaceship.api.facebook.OAuthBridge.initialize");
				}catch( $e:Error ) { Out.debug( this, 'error: ' + $e ); }
			}
			_logoutHandler();
		};

		// login
		// jk: options should follow Facebook's documentation:
		// jk: ex: { perms:"publish_stream"}
		public function login($options:Object = null):void {
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_START));
			if(Environment.IS_IN_BROWSER)
			{
				// sk: if we have a type we know we are not using FBJS to authenticate: just set the $options to the url after we build it from the permissions
				var type:String = _getFlashVar( 'fb_type' );
				if( type != '')
				{
					var _url:String = _getAuthorizationURL( $options.perms.split( ',' ), type );
					$options = _url;
				}
				
				// sk: same method name, different implementation depending on use (using FBJS or using iframe)
				//		else we are opening the url in the same page using FBML Bridge
				if( _getFlashVar( 'fb_environment' ).toLowerCase() == "iframe" )
					ExternalInterface.call("com.bigspaceship.api.facebook.OAuthBridge.login",$options);
				else if( _getFlashVar( 'fb_environment' ).toLowerCase() == "fbml" )
					_openURL( String( $options ) );
					
			}else
			{
				_session = _debugSession;
				dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN));
				dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));			
			}
		}
		
		//private function _loginHandler($api_key:String,$session:Object,$perms:String = ""):void {
		private function _loginHandler($session:Object, $perms:String = null):void {
			Out.info( this, "_loginHandler: " +  $session);
			_session = new OAuthSession($session);
			if( $perms )
			{
				setPermissions( $perms );
			}
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN));
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));
		}
		
		private function _loginCancelHandler():void {
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGIN_PROCESS_COMPLETE));			
		}

		// logout
		public function logout():void { 
			if( Environment.IS_IN_BROWSER )
			{
				try
				{
					ExternalInterface.call("com.bigspaceship.api.facebook.OAuthBridge.logout");
				}catch( $e:Error ) { Out.debug( this, 'error: ' + $e ); }
			}
			else _logoutHandler();
		}
		
		public function setPermissions( $perms:String ):void
		{
			_perms = new OAuthPerms( $perms );
		};
		
		private function _logoutHandler():void {
			_session = null;
			dispatchEvent(new FacebookAuthEvent(FacebookAuthEvent.LOGOUT));			
		}
		
		private function _openURL( $url:String ):void
		{
			if( _getFlashVar("fb_local_connection") )
			{
				var _localConn:LocalConnection = new LocalConnection();
				_localConn.send( _getFlashVar("fb_local_connection"), "callFBJS", "document.setLocation", [$url] );
			}
		};
		
		// sk: build the url for authorization
		private function _getAuthorizationURL( $perms:Array, $type:String = 'page' ):String
		{
			// sk: $type should be one of the 1st two, you can also use 'wap' and 'touch' so let's put them in as well
			// http://developers.facebook.com/docs/authentication/
			if( $type != 'page' && $type != 'popup' && $type != 'wap' && $type != 'touch' )
			{
				throw new Error("Type of authentication page is unknown: " + $type);
			}
			
			var i:uint = $perms.length;
			var scope = '';
			if( i )
			{
				while( i-- )
				{
					scope += $perms[i] + ",";
				}
				// sk: remove last comma
				scope = scope.slice( 0, -1 );
			}
			
			return apiPath + "/oauth/authorize"
                    + "?client_id=" + _getFlashVar( 'fb_app_id' ) 
                    + "&redirect_uri=" + _getFlashVar( 'fb_redirect' )
                    + "&type=user_agent"
                    + "&scope=" + scope
                    + "&display=" + $type;
		};
		        
        public function get apiPath():String
        {
            return useSecuredPath ? apiSecuredPath : apiUnsecuredPath;
        };

		private function _getFlashVar($id:String):String
		{
			if( _loaderInfo.parameters[$id] && _loaderInfo.parameters[$id] != "" ) return _loaderInfo.parameters[$id];
			return null;
		};
	}
}