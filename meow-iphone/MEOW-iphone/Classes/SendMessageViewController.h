//
//  SendMessageViewController.h
//  MEOW-iphone
//
//  Created by andycat on 21/09/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPUserCoreDataStorage.h"

@interface SendMessageViewController : UIViewController {

	UINavigationController *navController;
	
	IBOutlet UITextField *recipient, *subject;
	IBOutlet UITextView *message;
	
	BOOL keyboardIsShown;
	UIScrollView *scrollView;
	
	int threadId;
	NSString *initialRecipient;
	
	XMPPUserCoreDataStorage *xmpp_recipient;
}

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UITextField *recipient, *subject; 
@property (nonatomic, retain) UITextView *message;
@property (nonatomic, retain) NSString *initialRecipient;
@property (nonatomic, assign) int threadId;
@property (nonatomic, retain) XMPPUserCoreDataStorage *xmpp_recipient;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

-(IBAction) sendMessage:(id)sender;
-(void) doSendMessage:(NSString *) title withBody:(NSString *)body toRecipient:(NSString *) recipientstr;

@end
