//
//  MessageThreadViewController.h
//  MEOW-iphone
//
//  Created by andycat on 21/09/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageThreadViewController : UIViewController {

	
	IBOutlet UIWebView *threadText;
	NSString *threadString;
	UINavigationController *navController;
	int msgid;
	NSString *threadSender;
	
}

@property (nonatomic, retain) IBOutlet UIWebView *threadText;
@property (nonatomic, retain) NSString *threadString;
@property (nonatomic, assign) int msgid;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) NSString *threadSender;

-(void) doGetThread:(int) msgid;

-(IBAction) doReply:(id) sender;
-(IBAction) doTrash:(id) sender;

@end
