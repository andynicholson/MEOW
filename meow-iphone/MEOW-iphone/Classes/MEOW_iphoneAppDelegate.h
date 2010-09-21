//
//  MEOW_iphoneAppDelegate.h
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SERVICE_URL @"http://meow.infiniterecursion.com.au/json/"


@class HomeViewController;

@interface MEOW_iphoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
	IBOutlet UINavigationController*  myNavigationController;

	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController*  myNavigationController;


@end

