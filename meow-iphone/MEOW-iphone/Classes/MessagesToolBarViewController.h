//
//  MessagesToolBarViewController.h
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesViewController.h"

@interface MessagesToolBarViewController : UIViewController {

	UIView *view;
	UITableView *topView;
	
	MessagesViewController *mvc;
	
	//Buttons on toolbar
	UIBarButtonItem *newmsg;
	UIBarButtonItem *personal;
	UIBarButtonItem *groups;
	UIBarButtonItem *publicbtn;
	
	
	NSTimer *refreshTimer;
	
}

@property (nonatomic,retain) IBOutlet UIView *view;
@property (nonatomic,retain) IBOutlet UITableView *topView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *newmsg, *personal, *groups, *publicbtn;
@property (nonatomic, retain) NSTimer *refreshTimer;

-(IBAction) userWantsPublicMessaging;
-(IBAction) userWantsPersonalMessaging;
-(IBAction) userWantsGroupsMessaging;
-(IBAction) userWantsToWriteNewMessage;

-(void) mvcWantsTableReload;

@end
