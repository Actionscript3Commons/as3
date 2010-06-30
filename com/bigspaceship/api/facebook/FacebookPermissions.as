/**
 * FacebookPermissions by Big Spaceship. 2010
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
	 * The <code>FacebookPermissions()</code> Class holds all the CONSTANTS for facebook extended permissions
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9.0.0
	 * 
	 * @version			1.0
	 * 
	 * @author 			Stephen Koch
	 * @since  			2010.03.19
	 * @reference 		http://developers.facebook.com/docs/authentication/permissions
	 * @note			Starting June 30, 2010, all applications will be able to access only a user's public data unless the user grants your application the extended permissions it needs.
	 * 					Read the upgrade guide for details. ( http://developers.facebook.com/docs/guides/upgrade#permissions ) 
	 */
	public class FacebookPermissions
	{
		// publishing permissions
		public static const PUBLISH_TO_STREAM			: String = 'publish_stream';
		public static const CREATE_EVENT				: String = 'create_event';
		public static const RSVP_EVENT					: String = 'rsvp_event';
		public static const SMS							: String = 'sms';
		public static const OFFLINE_ACCESS				: String = 'offline_access';

		// data permissions
		public static const EMAIL						: String = 'email';
		public static const READ_INSIGHT				: String = 'read_insights';
		public static const READ_STREAM					: String = 'read_stream';
		// new api
		public static const USER_ABOUT_ME            	: String = 'user_about_me';
		public static const FRIENDS_ABOUT_ME         	: String = 'friends_about_me';
		public static const USER_ACTIVITIES          	: String = 'user_activities';
		public static const FRIENDS_ACTIVITIES       	: String = 'friends_activities';
		public static const USER_BIRTHDAY            	: String = 'user_birthday';
		public static const FRIENDS_BIRTHDAY         	: String = 'friends_birthday';
		public static const USER_EDUCATION_HISTORY   	: String = 'user_education_history';
		public static const FRIENDS_EDUCATION_HISTORY	: String = 'friends_education_history';
		public static const USER_EVENTS              	: String = 'user_events';
		public static const FRIENDS_EVENTS           	: String = 'friends_events';
		public static const USER_GROUPS              	: String = 'user_groups';
		public static const FRIENDS_GROUPS           	: String = 'friends_groups';
		public static const USER_HOMETOWN            	: String = 'user_hometown';
		public static const FRIENDS_HOMETOWN         	: String = 'friends_hometown';
		public static const USER_INTERESTS           	: String = 'user_interests';
		public static const FRIENDS_INTERESTS        	: String = 'friends_interests';
		public static const USER_LIKES               	: String = 'user_likes';
		public static const FRIENDS_LIKES            	: String = 'friends_likes';
		public static const USER_LOCATION            	: String = 'user_location';
		public static const FRIENDS_LOCATION         	: String = 'friends_location';
		public static const USER_NOTES               	: String = 'user_notes';
		public static const FRIENDS_NOTES            	: String = 'friends_notes';
		public static const USER_ONLINE_PRESENCE     	: String = 'user_online_presence';
		public static const FRIENDS_ONLINE_PRESENCE  	: String = 'friends_online_presence';
		public static const USER_PHOTO_VIDEO_TAGS    	: String = 'user_photo_video_tags';
		public static const FRIENDS_PHOTO_VIDEO_TAGS 	: String = 'friends_photo_video_tags';
		public static const USER_PHOTOS              	: String = 'user_photos';
		public static const FRIENDS_PHOTOS           	: String = 'friends_photos';
		public static const USER_RELATIONSHIPS       	: String = 'user_relationships';
		public static const FRIENDS_RELATIONSHIPS    	: String = 'friends_relationships';
		public static const USER_RELIGION_POLITICS   	: String = 'user_religion_politics';
		public static const FRIENDS_RELIGION_POLITICS	: String = 'friends_religion_politics';
		public static const USER_STATUS              	: String = 'user_status';
		public static const FRIENDS_STATUS           	: String = 'friends_status';
		public static const USER_VIDEOS              	: String = 'user_videos';
		public static const FRIENDS_VIDEOS           	: String = 'friends_videos';
		public static const USER_WEBSITE             	: String = 'user_website';
		public static const FRIENDS_WEBSITE          	: String = 'friends_website';
		public static const USER_WORK_HISTORY        	: String = 'user_work_history';
		public static const FRIENDS_WORK_HISTORY     	: String = 'friends_work_history';
		public static const READ_FRIENDLISTS         	: String = 'read_friendlists';
		public static const READ_REQUESTS            	: String = 'read_requests';
		
		// depricated
		public static const READ_MAIL					: String = 'read_mailbox';
		public static const STATUS_UPDATE				: String = 'status_update';
		public static const PHOTO_UPLOAD				: String = 'photo_upload';
		public static const VIDEO_UPLOAD				: String = 'video_upload';
		public static const CREATE_NOTE					: String = 'create_note';
		public static const SHARE_ITEM					: String = 'share_item';
		
	};
};

