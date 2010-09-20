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
	NSString *_username;
	NSString *_password;
	
	//Messages
	//NSArray of MEOW_UserMessage
	NSMutableArray *_messages;
	int viewing_message_types;
	
	
	//Groups
	//XXX
	
	//Contacts
	// Done by XMPP library.
	
}

@property (nonatomic, assign) BOOL logged_in;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) int viewing_message_types;

//Method used as wrapper to load messages into user's session as recieved from middleware
//
-(void) addMessage:(NSString *)body withTitle:(NSString*)title fromSender:(NSString *)sender 
		atDateTime:(NSString *)datetime withType:(int )type;

-(NSArray *)userMessages;


-(NSArray *) publicUserMessages;
-(NSArray *) privateUserMessages;
-(NSArray *) groupUserMessages;



+ (MEOW_UserState *)sharedMEOW_UserState;

@end
