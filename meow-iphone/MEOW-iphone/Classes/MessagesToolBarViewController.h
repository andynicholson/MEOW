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
}

@property (nonatomic,retain) IBOutlet UIView *view;
@property (nonatomic,retain) IBOutlet UITableView *topView;

@end
