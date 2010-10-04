//
//  MEOW_iphoneAppDelegate.h
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPRoom.h"

#define SERVICE_URL @"http://meow.infiniterecursion.com.au/json/"

#define kKeyboardAnimationDuration 0.3

@class HomeViewController;
//XMPP classes

@class XMPPStream;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;


@interface MEOW_iphoneAppDelegate : NSObject <UIApplicationDelegate, XMPPRoomDelegate> {
    UIWindow *window;
    
	IBOutlet UINavigationController*  myNavigationController;

	//XMPP
	XMPPStream *xmppStream;
	XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isOpen;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController*  myNavigationController;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

-(void) xmppInit;

@end

