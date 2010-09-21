//
//  MEOW_UserMessage.h
//  MEOW-iphone
//
//  Created by andycat on 2/09/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSG_PRIVATE 0
#define MSG_GROUP 1
#define MSG_PUBLIC 2

@interface MEOW_UserMessage : NSObject {

	NSString *sender;
	NSString *datetime;
	NSString *readat_datetime;
	NSString *message;
	NSString *title;
	int type;
	int msgid;
}

@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSString *datetime;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *readat_datetime;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) int msgid;

@end
