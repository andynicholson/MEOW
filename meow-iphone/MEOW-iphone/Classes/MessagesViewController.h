//
//  MessagesViewController.h
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessagesToolBarViewController;

@interface MessagesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *msgsTable;
	
	NSIndexPath *indexpathDeleting;
	BOOL deleting;
	
}

@property (nonatomic, retain) IBOutlet UITableView* msgsTable;
@property (nonatomic, retain) NSIndexPath *indexpathDeleting;



-(void) doRefreshInbox;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
