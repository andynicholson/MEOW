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
@synthesize username = _username;
@synthesize password = _password;

-(id) init {
	if (self = [super init]){
		_messages = [[NSMutableArray alloc] init];		
	}
	return self;
	
}


-(void) addMessage:(NSString *)body withTitle:(NSString*)title fromSender:(NSString *)sender 
		atDateTime:(NSString *)datetime withType:(NSString *)type {
	
	
	MEOW_UserMessage *msg = [[MEOW_UserMessage alloc] init];
	[msg setType:type];
	[msg setTitle:title];
	[msg setMessage:body];
	[msg setSender:sender];
	[msg setDatetime:datetime];
	
	[_messages addObject:msg];
	
	[msg release];
	
}

-(NSArray *)userMessages {
	
	NSArray *array = [[_messages copy] autorelease];
	return array;
	
}

-(void)dealloc {
	[super dealloc];
	[_username release];
	[_password release];
	
	[_messages release];
	
}

@end
