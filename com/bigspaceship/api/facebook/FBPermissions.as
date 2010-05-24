/**
 * FBPermissions by Big Spaceship. 2010
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
	 * The <code>FBPermissions()</code> Class holds all the CONSTANTS for facebook extended permissions
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9.0.0
	 * 
	 * @version			1.0
	 * 
	 * @author 			Stephen Koch
	 * @since  			2010.03.19
	 * @reference 		http://wiki.developers.facebook.com/index.php/Extended_permissions
	 */
	public class FBPermissions
	{		
		public static const PERMS_PUBLISH_TO_STREAM	: String = 'publish_stream';
		public static const PERMS_READ_STREAM		: String = 'read_stream';
		public static const PERMS_EMAIL				: String = 'email';
		public static const PERMS_READ_MAIL			: String = 'read_mailbox';
		public static const PERMS_OFFLINE_ACCESS	: String = 'offline_access';
		public static const PERMS_CREATE_EVENT		: String = 'create_event';
		public static const PERMS_RSVP_EVENT		: String = 'rsvp_event';
		public static const PERMS_SMS				: String = 'sms';
		public static const PERMS_STATUS_UPDATE		: String = 'status_update';
		public static const PERMS_PHOTO_UPLOAD		: String = 'photo_upload';
		public static const PERMS_VIDEO_UPLOAD		: String = 'video_upload';
		public static const PERMS_CREATE_NOTE		: String = 'create_note';
		public static const PERMS_SHARE_ITEM		: String = 'share_item';
		
		// new API
		public static const PERMS_USER_PHOTOS		: String = 'user_photos';
		
	};
};

