//
//  MEOW_UserState.m
//  MEOW-iphone
//
//  Created by andycat on 2/09/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "MEOW_UserState.h"
#import "MEOW_UserMessage.h"
#import "SynthesizeSingleton.h"

@implementation MEOW_UserState

SYNTHESIZE_SINGLETON_FOR_CLASS(MEOW_UserState);

@synthesize logged_in = _logged_in;
@synthesize needsMsgTableRefresh = _needsMsgTableRefresh;
@synthesize username = _username;
@synthesize password = _password;

@synthesize viewing_message_types;

@synthesize delayTimer;

-(id) init {
	if (self = [super init]){
		[self initialisation];		
	}
	return self;
	
}


-(void) initialisation {
	
	if (_messages) {
		[_messages release];
	}
	_messages = [[NSMutableArray alloc] init];		
	
	viewing_message_types = MSG_PRIVATE;
	
	
	
}


+(void) processReturnedInbox:(NSArray *)resultdict {
	
	//cache inbox messages sent back.
	NSEnumerator *enumerator = [resultdict objectEnumerator];
	id anObject;
	
	while (anObject = [enumerator nextObject]) {
		/* code to act on each element as it is returned */
		NSLog(@"object is %@" , anObject);
		NSArray *msg = (NSArray *) anObject;
		
		[[MEOW_UserState sharedMEOW_UserState] addMessage:[msg objectAtIndex:2] withTitle:[msg objectAtIndex:1]
											   fromSender:[msg objectAtIndex:3] atDateTime:[msg objectAtIndex:4]
												 withType:MSG_PRIVATE withID:[msg objectAtIndex:0]];
		
	}
	
	
}


-(void) addMessage:(NSString *)body withTitle:(NSString*)title fromSender:(NSString *)sender 
		atDateTime:(NSString *)datetime withType:(int) type withID:(int) msgid {
	
	
	MEOW_UserMessage *msg = [[MEOW_UserMessage alloc] init];
	[msg setType:type];
	[msg setTitle:title];
	[msg setMessage:body];
	[msg setSender:sender];
	[msg setDatetime:datetime];
	//XXX fix this
	[msg setReadat_datetime:datetime];
	//set type (private, group, public)
	[msg setType:type];
	[msg setMsgid:msgid];
	
	//add msg into array
	[_messages addObject:msg];
	
	[msg release];
	
}


/* Return the desired form of user messages
 *
 */
-(NSArray *)userMessages {	
	
	switch (viewing_message_types) {
		case MSG_PRIVATE:
			return [self privateUserMessages];
			break;
		
		case MSG_GROUP:
			return [self groupUserMessages];
			break;

		case MSG_PUBLIC:
			return [self publicUserMessages];
			break;
	
			
		default:
			return [self privateUserMessages];
			break;
	}
	
	
}

/* Return only public user messages
 *
 */

-(NSArray *) publicUserMessages {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (int i=0; i < [_messages count]; i++) {
		MEOW_UserMessage *msg = [_messages objectAtIndex:i];
		if ([msg type] == MSG_PUBLIC) {
			[array addObject:msg];
		}
			
	}
	return array;

	
}

/* Return only group messages
 *
 */
-(NSArray *) groupUserMessages {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i=0; i < [_messages count]; i++) {
		MEOW_UserMessage *msg = [_messages objectAtIndex:i];
		if ([msg type] == MSG_GROUP) {
			[array addObject:msg];
		}
		
	}
	return array;
}

/* Return only private user messages
 *
 */
-(NSArray *) privateUserMessages {	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i=0; i < [_messages count]; i++) {
		MEOW_UserMessage *msg = [_messages objectAtIndex:i];
		if ([msg type] == MSG_PRIVATE) {
			[array addObject:msg];
		}
		
	}
	return array;
}


-(void)dealloc {
	[super dealloc];
	[_username release];
	[_password release];	
	[_messages release];
	
}

@end
