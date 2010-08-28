//
//  MessagesToolBarViewController.h
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessagesToolBarViewController : UIViewController {

	UIView *view;
	UIView *topView;
}

@property (nonatomic,retain) IBOutlet UIView *view;
@property (nonatomic,retain) IBOutlet UIView *topView;

@end
