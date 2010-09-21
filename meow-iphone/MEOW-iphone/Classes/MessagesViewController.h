//
//  MessagesViewController.h
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessagesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UIView *view;
	IBOutlet UITableView *msgsTable;
	
	NSIndexPath *indexpathDeleting;
	BOOL deleting;
}

@property (nonatomic, retain) IBOutlet UITableView* msgsTable;
@property (nonatomic, retain) NSIndexPath *indexpathDeleting;
@property (nonatomic,retain) IBOutlet UIView *view;

-(void) doRefreshInbox;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
