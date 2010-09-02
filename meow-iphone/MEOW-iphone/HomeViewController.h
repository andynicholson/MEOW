//
//  HomeViewController.h
//  MEOW-iphone
//
//  Created by andycat on 26/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController {

	UIView *view;
	
	UIButton *groups, *contacts, *messages, *about;
	UIButton *login , *register_btn;
}


@property (nonatomic, retain) IBOutlet UIView *view;

@property (nonatomic, retain) IBOutlet UIButton *groups;
@property (nonatomic, retain) IBOutlet UIButton *contacts;
@property (nonatomic, retain) IBOutlet UIButton *messages;
@property (nonatomic, retain) IBOutlet UIButton *about;
@property (nonatomic, retain) IBOutlet UIButton *login;
@property (nonatomic, retain) IBOutlet UIButton *register_btn;


-(IBAction) doRegisterScreen:(id)sender;
-(IBAction) doLoginScreen:(id)sender;
-(IBAction) doMessagesScreen:(id)sender;
-(IBAction) doContactsScreen:(id)sender;
-(IBAction) doGroupsScreen:(id)sender;
-(IBAction) doAboutScreen:(id)sender;



@end
