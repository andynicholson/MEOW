//
//  MEOW_iphoneViewController.h
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEOW_iphoneViewController : UIViewController {

	//TextFields to hook up username, password,
	UITextField *username, *password;
	
	// reg_user, reg_email, reg_pass1, reg_pass2
	UITextField *reg_username, *reg_password1, *reg_password2, *reg_email;
	
	
	
}

@property (nonatomic, retain) IBOutlet UITextField  *username;
@property (nonatomic, retain) IBOutlet UITextField   *password;
@property (nonatomic, retain) IBOutlet UITextField  *reg_username;
@property (nonatomic, retain)  IBOutlet UITextField  *reg_password1;
@property (nonatomic, retain)  IBOutlet UITextField  *reg_password2;
@property (nonatomic, retain)  IBOutlet UITextField  *reg_email;


-(IBAction) doRegister:(id)sender;
-(IBAction) doLogin:(id)sender;

@end

