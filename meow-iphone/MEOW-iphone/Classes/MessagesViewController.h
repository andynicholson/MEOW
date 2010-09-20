//
//  MessagesViewController.h
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessagesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {

	UITableView *tableView;
	
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
