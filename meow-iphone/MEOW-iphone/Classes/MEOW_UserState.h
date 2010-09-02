//
//  MEOW_UserState.h
//  MEOW-iphone
//
//  Created by andycat on 2/09/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MEOW_UserState : NSObject {

	BOOL _logged_in;
	NSString *username;
	NSString *password;
	
	//Messages
	
	//Groups
	
	//Contacts
	// Done by XMPP library.
	
}

@property (nonatomic, assign) BOOL logged_in;


+ (MEOW_UserState *)sharedMEOW_UserState;

@end
