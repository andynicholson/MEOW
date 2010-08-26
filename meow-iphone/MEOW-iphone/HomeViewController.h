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
	
}


@property (nonatomic, retain) IBOutlet UIView *view;

-(IBAction) doRegister:(id)sender;
-(IBAction) doLogin:(id)sender;



@end
